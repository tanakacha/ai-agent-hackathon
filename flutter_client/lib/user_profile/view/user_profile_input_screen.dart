import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../auth/repository/user_profile_dto.dart';
import '../../goal_input/view/goal_input_screen.dart';
import '../view_model/user_profile_notifier.dart';
import '../view_model/user_profile_state.dart';

class UserProfileInputScreen extends HookConsumerWidget {
  final String uid;

  const UserProfileInputScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = useTextEditingController();
    final ageController = useTextEditingController();
    final userType = useState<UserType>(UserType.student);
    final hoursPerDay = useState<int>(2);
    final daysPerWeek = useState<int>(3);
    final experienceLevel = useState<ExperienceLevel>(ExperienceLevel.beginner);

    final userProfileState = ref.watch(userProfileNotifierProvider);
    final userProfileNotifier = ref.read(userProfileNotifierProvider.notifier);

    useEffect(() {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.displayName != null) {
        nicknameController.text = currentUser.displayName!;
      }
      return null;
    }, const []);

    Future<void> handleSubmit() async {
      if (nicknameController.text.trim().isEmpty || ageController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ニックネームと年齢を入力してください')),
        );
        return;
      }

      final age = int.tryParse(ageController.text.trim());
      if (age == null || age < 1 || age > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('有効な年齢を入力してください（1-120）')),
        );
        return;
      }

      await userProfileNotifier.createUserProfile(
        uid: uid,
        nickname: nicknameController.text.trim(),
        age: age,
        userType: userType.value,
        availableHoursPerDay: hoursPerDay.value,
        availableDaysPerWeek: daysPerWeek.value,
        experienceLevel: experienceLevel.value,
      );
    }

    ref.listen<UserProfileState>(userProfileNotifierProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GoalInputScreen(uid: uid),
            ),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロファイル設定'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.person_add,
              size: 60,
              color: Colors.blue[700],
            ),
            const SizedBox(height: 16),
            Text(
              'プロファイルを設定してください',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'あなたに最適なロードマップを作成するために、以下の情報を教えてください。',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            
            // ニックネーム入力
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                labelText: 'ニックネーム',
                hintText: '表示名を入力してください',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 年齢入力
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '年齢',
                hintText: '例: 25',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // ユーザータイプ選択
            Text(
              'ユーザータイプ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<UserType>(
              value: userType.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: UserType.values.map((type) {
                String label;
                switch (type) {
                  case UserType.student:
                    label = '学生';
                    break;
                  case UserType.professional:
                    label = '会社員';
                    break;
                  case UserType.freelancer:
                    label = 'フリーランス';
                    break;
                  case UserType.hobbyist:
                    label = '趣味・個人学習';
                    break;
                }
                return DropdownMenuItem(
                  value: type,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) => userType.value = value!,
            ),
            const SizedBox(height: 24),
            
            // 1日の利用可能時間
            Text(
              '1日の利用可能時間: ${hoursPerDay.value}時間',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Slider(
              value: hoursPerDay.value.toDouble(),
              min: 1,
              max: 8,
              divisions: 7,
              label: '${hoursPerDay.value}時間',
              onChanged: (value) => hoursPerDay.value = value.round(),
            ),
            const SizedBox(height: 16),
            
            // 週の利用可能日数
            Text(
              '週の利用可能日数: ${daysPerWeek.value}日',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Slider(
              value: daysPerWeek.value.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              label: '${daysPerWeek.value}日',
              onChanged: (value) => daysPerWeek.value = value.round(),
            ),
            const SizedBox(height: 24),
            
            // 経験レベル選択
            Text(
              '経験レベル',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ExperienceLevel>(
              value: experienceLevel.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: ExperienceLevel.values.map((level) {
                String label;
                switch (level) {
                  case ExperienceLevel.beginner:
                    label = '初心者';
                    break;
                  case ExperienceLevel.intermediate:
                    label = '中級者';
                    break;
                  case ExperienceLevel.advanced:
                    label = '上級者';
                    break;
                  case ExperienceLevel.expert:
                    label = 'エキスパート';
                    break;
                }
                return DropdownMenuItem(
                  value: level,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) => experienceLevel.value = value!,
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: userProfileState.maybeWhen(
                  loading: () => null,
                  orElse: () => handleSubmit,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: userProfileState.maybeWhen(
                  loading: () => const CircularProgressIndicator(color: Colors.white),
                  orElse: () => const Text(
                    '次へ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
