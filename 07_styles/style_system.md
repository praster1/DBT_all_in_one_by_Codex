# DBT All In One 스타일 시스템 v1

## 1) 목적
문서 전체의 시각/구조 일관성을 유지하기 위해 수동 서식이 아닌 **Named Style** 기반으로만 편집한다.

## 2) 필수 스타일 세트
- Title
- Subtitle
- Part Title
- Chapter Title
- Heading 1
- Heading 2
- Heading 3
- Body
- Body Small
- Bullet List
- Numbered List
- Code Block
- Command Block
- Table Header
- Table Body
- Caption
- Note
- Warning
- Example
- Quote

## 3) 본문 규칙
1. 본문 정렬: 좌측 정렬(문서 전체 고정)
2. 첫 줄 들여쓰기: 전역에서 한 가지 방식만 사용
3. 목록: hanging indent 고정
4. 표: 셀 패딩/헤더 강조 방식 고정

## 4) 코드/명령어 규칙
1. 항상 좌측 정렬
2. 모노스페이스 폰트 고정
3. 배경색/테두리/위아래 여백 통일
4. 언어 라벨 표기 통일(예: `sql`, `bash`, `yaml`, `json`, `python`, `text`)
5. 실행용 블록에는 파일 경로·실행 순서·기대 결과를 함께 명시
6. 긴 명령어 줄바꿈 방식 고정(continuation 스타일 통일)

## 5) 폰트/컬러 최소 원칙
- 본문용 1종, 제목용 1종, 코드용 1종(최대 3종)
- 색상 팔레트 최소화
  - 기본 텍스트
  - 제목/강조
  - 코드/박스 중립
  - Warning/Note 포인트

## 6) 콜아웃 정책
- Note: 판단 팁/운영 권장사항
- Warning: 장애 위험/호환성 리스크
- Example: 예제 트랙 연결 설명
- Quote: 정의/원칙 인용

> 같은 종류의 정보는 같은 콜아웃만 사용한다. 임의 박스 스타일 추가 금지.

## 7) 금지 규칙
- 수동 폰트 변경(부분 강조 제외)
- 임의 줄간격/문단 간격 남발
- 코드 블록 중앙 정렬
- 장마다 다른 표 스타일 사용
- "이 장의 로드맵" 박스의 기계적 반복

## 8) 스타일 변경 절차
1. 스타일 이슈 발견
2. 개별 문단을 직접 수정하지 말고 스타일 정의부터 수정
3. 샘플 2개 챕터에 시범 적용
4. 전체 문서 일괄 반영
5. 렌더(PDF/DOCX) 검수
