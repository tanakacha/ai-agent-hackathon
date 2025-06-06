package com.example.dto;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Node {
	private String id;
	private String map_id;
	private String title;
	private String node_type;
	private int duration;
	private String description;
	private int progress_rate;
	private String parent_id;
	private List<String> children_ids;
	private Date created_at;
	private Date updated_at;
	private Date due_at;
	private Date finished_at;
	
}
