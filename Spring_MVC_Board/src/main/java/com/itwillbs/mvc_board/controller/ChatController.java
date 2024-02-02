package com.itwillbs.mvc_board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatController {
	@GetMapping("ChatMain")
	public String chatMain(HttpSession session, Model model) {
		String sId = (String) session.getAttribute("sId");
		if (sId == null) {
			model.addAttribute("msg", "로그인 후 사용 가능합니다.");
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		}
		return "chat/main";
	}
}
