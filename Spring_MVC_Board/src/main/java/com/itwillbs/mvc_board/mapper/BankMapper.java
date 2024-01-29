package com.itwillbs.mvc_board.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.mvc_board.vo.ResponseTokenVO;

@Mapper
public interface BankMapper {

	// 아이디 조회(엑세스토큰 중복 시 처리를 위함)
	String selectId(Map<String, Object> map);

	// 엑세스 토큰 저장(파라미터 2개 전달받을 경우)
//	void insertAccessToken(@Param("id") String id, @Param("responseToken") ResponseTokenVO responseToken);

	// 엑세스 토큰 저장(Map 타입으로 전달받을 경우)
	void insertAccessToken(Map<String, Object> map);

	// 엑세스 토큰 업데이트
	void updateAccessToken(Map<String, Object> map);
	
	// 사용자 토큰 정보 조회
	Map<String, String> selectBankUserInfo(String id);

	// 관리자 엑세스토큰 조회
	String selectAdminAccessToken();

	
}
