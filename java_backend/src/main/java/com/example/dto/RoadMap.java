package com.example.model;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RoadMap {
	private String id;
	private String user_id;
	private String title;
	private String objective;
	private String profile;
	private Date deadline;
	private Date created_at;
	private Date updated_at;
}
