package com.itwillbs.mvc_board.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class FintechController {
	// 로그 출력을 위한 기본 라이브러리(org.slf4j.Logger 타입) 변수 선언
	// => org.slf4j.LoggerFactory.getLogger() 메서드 호출하여 Logger 객체 리턴받아 사용 가능
	//    파라미터 : 로그를 사용하여 다룰 현재 클래스 지정(해당 클래스에서 발생한 로그로 처리)
	private static final Logger logger = LoggerFactory.getLogger(FintechController.class);
	// => Logger 객체의 다양한 로그 출력 메서드(info, debug, warn, error 등) 활용하여 로그 출력 가능
	//    (각 메서드는 로그의 심각도(레벨)에 따라 구별하는 용도로 사용)
	// -------------------------------------------------------------------------
	// "/FintechMain" 매핑 => fintech/main.jsp 페이지 포워딩
	@GetMapping("FintechMain")
	public String FintechMain() {
		return "fintech/main";
	}
	
	@GetMapping("callback") // 기본 get매핑
	public String callback(@RequestParam Map<String, String> authResponse) {
		logger.info("authResponse : " + authResponse.toString()); // syso 아니므로 toString() 붙여야함
		return "";
	}
}
