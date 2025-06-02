package com.example.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NodeResponse {
	private String id;
	private String text;
	private int positionDx;
	private int positionDy;
	private List<String> next;


}

    //  {
    //    "positionDx": 187.5,
    //    "positionDy": 137.5,
    //    "size.width": 200.0,
    //    "size.height": 100.0,
    //    "text": "Node 2",
    //    "textColor": 4278190080,
    //    "fontFamily": null,
    //    "textSize": 24.0,
    //    "textIsBold": false,
    //    "id": "f7ca0b2a-1163-4316-991b-a0005071e809",
    //    "kind": 0,
    //    "handlers": [
    //      1,
    //      0,
    //      3,
    //      2
    //    ],
    //    "handlerSize": 25.0,
    //    "backgroundColor": 4294967295,
    //    "borderColor": 4280391411,
    //    "borderThickness": 3.0,
    //    "elevation": 4.0,
    //    "data": null,
    //    "next": [
    //      {
    //        "destElementId": "f2985f5c-5919-40b2-9bfa-0e1648dc37cb",
    //        "arrowParams": {
    //          "thickness": 1.7,
    //          "headRadius": 6.0,
    //          "tailLength": 25.0,
    //          "color": 4278190080,
    //          "style": 0,
    //          "tension": 1.0,
    //          "startArrowPositionX": -1.0,
    //          "startArrowPositionY": 0.0,
    //          "endArrowPositionX": 0.0,
    //          "endArrowPositionY": 1.0
    //        },
    //        "pivots": []
    //      }
