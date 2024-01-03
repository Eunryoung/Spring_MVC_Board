package com.itwillbs.mvc_board.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.mvc_board.vo.BoardVO;

@Mapper
public interface BoardMapper {

	int insertBoard(BoardVO board);

	List<BoardVO> selectBoardList(
			@Param("searchType") String searchType, 
			@Param("searchKeyword") String searchKeyword, 
			@Param("startRow") int startRow, 
			@Param("listLimit") int listLimit);

	int selectBoardListCount(@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);

	
	BoardVO selectBoard(int board_num);

	void updateReadcount(BoardVO board);

	int deleteBoard(BoardVO board);

	int updateBoardFile(BoardVO board);

	int updateBoard(BoardVO board);

	void updateBoardReSeq(BoardVO board);

	int insertReplyBoard(BoardVO board);

	int insertTinyReplyBoard(Map<String, String> map);

	List<Map<String, Object>> selectTinyReplyBoardList(int board_num);
//	List<Map<String, String>> selectTinyReplyBoardList(int board_num);

	Map<String, String> selectTinyReplyWriter(Map<String, String> map);

	int deleteTinyReplyBoard(Map<String, String> map);

}
