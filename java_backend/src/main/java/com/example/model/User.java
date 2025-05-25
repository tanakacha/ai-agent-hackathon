
package com.example.model;


public class User {
    private String id;
    private String name;
    private int age;

    // コンストラクタ・getter/setter
    public User() {}

    public User(String id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }
    public String getId() {
        return id;
    }
    public String getName() {
        return name;
    }
    public int getAge() {
        return age;
    }
    // Getter/Setter省略（Lombok推奨）
}
