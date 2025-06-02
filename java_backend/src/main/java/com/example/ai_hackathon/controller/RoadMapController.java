package com.example.ai_hackathon.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.dto.RoadMapResponse;
import com.example.service.RoadMapService;

import lombok.AllArgsConstructor;


@AllArgsConstructor
@RestController
@RequestMapping("/roadmap")
public class RoadMapController {
	private final RoadMapService roadMapService;


	@GetMapping("/{map_id}")
	public RoadMapResponse getRoadMap(@PathVariable String map_id) {
		System.out.println("map_id: " + map_id);
		return roadMapService.getRoadMapResponse(map_id);
	}
	
}
