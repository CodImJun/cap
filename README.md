# SAP CAP + PostgreSQL + Node.js Project

이 프로젝트는 SAP Cloud Application Programming Model (CAP)을 사용하여 PostgreSQL 데이터베이스와 Node.js 런타임으로 구성되었습니다.

## 프로젝트 구조

```
cap/
├── db/           # 데이터 모델 및 초기 데이터
├── srv/          # 서비스 정의 및 비즈니스 로직
├── app/          # UI 애플리케이션 (Fiori)
└── package.json  # 프로젝트 설정
```

## 사전 요구사항

1. Node.js (v18 이상)
2. PostgreSQL (v12 이상)
3. npm 또는 yarn

## 설치 및 실행

### 1. 의존성 설치
```bash
npm install
```

### 2. PostgreSQL 데이터베이스 설정
PostgreSQL 서버에서 데이터베이스를 생성합니다:
```sql
CREATE DATABASE cap_bookshop;
```

### 3. 환경 변수 설정
`.env` 파일에서 PostgreSQL 연결 정보를 수정합니다.

### 4. 데이터베이스 배포
```bash
npm run deploy
```

### 5. 애플리케이션 실행
개발 모드 (hot-reload 포함):
```bash
npm run watch
```

## 접속 정보
- 서비스 엔드포인트: http://localhost:4004
- CatalogService: http://localhost:4004/catalog/
- AdminService: http://localhost:4004/admin/
- Fiori Launchpad: http://localhost:4004/fiori.html

## 참고 자료
- [SAP CAP Documentation](https://cap.cloud.sap/docs/)
- [CAP PostgreSQL Plugin](https://cap.cloud.sap/docs/guides/databases-postgres)

