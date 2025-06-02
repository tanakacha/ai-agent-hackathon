package com.example.model;

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
	private String node_type; // Start, End, Normal
	private String parent_id;
	private List<String> children_ids;
	private String next_id;
	private Date created_at;
	private Date updated_at;


}
