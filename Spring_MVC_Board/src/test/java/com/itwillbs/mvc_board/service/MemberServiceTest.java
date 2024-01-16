package com.itwillbs.mvc_board.service;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.itwillbs.mvc_board.mapper.MemberMapper;
import com.itwillbs.mvc_board.vo.MemberVO;

// @RunWith 어노테이션을 사용하여 테스트에 사용할 스프링 빈을 자동 주입하는 역할의 클래스 지정
// => Spring 버전에 맞는 실행 클래스를 지정하되 xxx.class 형태로 지정
// => 해당 클래스 사용을 위해 spring-test 라이브러리 추가 필요(pom.xml에서 12번 라이브러리)
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"servlet-context.xml", "root-context.xml"})
public class MemberServiceTest {
	// 자동 주입으로 사용해야할 스프링 빈 객체가 있을 경우 @Autowired 어노테이션 사용하여 등록 가능
	// MemberMapper 객체 자동 주입
	@Autowired
	private MemberMapper mapper;
	
	@Test
	// 해당메서드의 이름을 갖되 앞에 test라는 이름을 갖고있음
	public void testGetMember() {
		// MemberMapper 객체의 selectMember() 메서드 호출하여 회원 정보 조회할 경우
		// MemberVO 객체가 필요한데 컨트롤러 등으로부터 파라미터 형식으로 전달받지 않고 테스트하므로
		// 임의의 객체를 생성하여 사용(필요한 데이터를 임의로 저장)
		MemberVO member = new MemberVO();
		member.setId("admin");
		
		// 테스트할 객체의 메서드가 있을 경우 호출하여 사용
		System.out.println("조회결과 : " + mapper.selectMember(member)); 
	}
}
