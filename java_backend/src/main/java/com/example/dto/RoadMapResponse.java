package com.example.dto;

import java.util.List;

import com.example.model.Node;
import com.example.model.NodeStyle;
import com.example.model.RoadMap;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RoadMapResponse {
	private RoadMap roadMap;
	private List<Node> nodes;
	private NodeStyle nodeStyle;
}
