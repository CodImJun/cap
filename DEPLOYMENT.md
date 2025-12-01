# SAP BTP PostgreSQL Trial 배포 가이드

이 문서는 SAP BTP Cloud Foundry 환경에서 PostgreSQL Trial 서비스를 사용하는 방법을 설명합니다.

## 사전 준비

### 1. 필수 도구 설치

```bash
# Cloud Foundry CLI 설치
# Windows: https://github.com/cloudfoundry/cli/releases
# Mac: brew install cloudfoundry/tap/cf-cli

# MTA Build Tool 설치
npm install -g mbt

# Cloud Foundry MTA Plugin 설치
cf install-plugin multiapps
```

### 2. SAP BTP 계정 준비

1. SAP BTP Trial 계정 생성: https://cockpit.hanatrial.ondemand.com
2. Cloud Foundry Environment 활성화
3. Space 생성 (예: dev, test, prod)

## 배포 단계

### Step 1: CF CLI 로그인

```bash
# API Endpoint는 BTP Cockpit에서 확인
cf api https://api.cf.{region}.hana.ondemand.com

# 로그인
cf login

# 조직 및 Space 선택
cf target -o {org-name} -s {space-name}
```

### Step 2: PostgreSQL 서비스 생성 (수동 방법)

```bash
# PostgreSQL Trial 서비스 생성
cf create-service postgresql-db trial cap-bookshop-db

# XSUAA 서비스 생성
cf create-service xsuaa application cap-bookshop-uaa -c xs-security.json

# 서비스 생성 확인
cf services
```

### Step 3: 로컬에서 빌드

```bash
# 프로젝트 루트에서 실행
npm install

# CAP 프로덕션 빌드
npm run build

# MTA 빌드
mbt build
```

### Step 4: BTP에 배포

```bash
# MTA 아카이브 배포
cf deploy mta_archives/cap-bookshop_1.0.0.mtar

# 또는 자동으로 서비스 생성하며 배포
cf deploy mta_archives/cap-bookshop_1.0.0.mtar --strategy blue-green
```

### Step 5: 배포 확인

```bash
# 애플리케이션 상태 확인
cf apps

# 서비스 바인딩 확인
cf services

# 애플리케이션 로그 확인
cf logs cap-bookshop-srv --recent

# 실시간 로그
cf logs cap-bookshop-srv
```

## 간단한 배포 (Cloud Foundry Manifest 사용)

MTA를 사용하지 않고 간단히 배포하는 방법:

```bash
# 1. 서비스 먼저 생성
cf create-service postgresql-db trial cap-bookshop-db
cf create-service xsuaa application cap-bookshop-uaa -c xs-security.json

# 2. 빌드
npm run build

# 3. manifest.yaml로 배포
cf push -f manifest.yaml
```

## 로컬에서 BTP PostgreSQL 연결하여 개발

### 1. 서비스 키 생성

```bash
# PostgreSQL 서비스 키 생성
cf create-service-key cap-bookshop-db local-dev-key

# 서비스 키 조회
cf service-key cap-bookshop-db local-dev-key
```

### 2. 로컬 환경 변수 설정

서비스 키에서 얻은 정보로 `.env` 파일 업데이트:

```env
# BTP PostgreSQL 연결 정보
POSTGRES_HOST=<hostname from service key>
POSTGRES_PORT=<port from service key>
POSTGRES_USER=<username from service key>
POSTGRES_PASSWORD=<password from service key>
POSTGRES_DATABASE=<dbname from service key>

# 또는 URI 형태
DATABASE_URL=<uri from service key>
```

### 3. 로컬에서 실행

```bash
npm run watch
```

## 주요 명령어

### 애플리케이션 관리

```bash
# 앱 시작/중지/재시작
cf start cap-bookshop-srv
cf stop cap-bookshop-srv
cf restart cap-bookshop-srv

# 앱 삭제
cf delete cap-bookshop-srv

# 앱 환경 변수 확인
cf env cap-bookshop-srv

# 앱 스케일링
cf scale cap-bookshop-srv -i 2 -m 512M
```

### 서비스 관리

```bash
# 서비스 목록
cf services

# 서비스 상세 정보
cf service cap-bookshop-db

# 서비스 삭제
cf delete-service cap-bookshop-db

# 서비스 바인딩 해제
cf unbind-service cap-bookshop-srv cap-bookshop-db
```

### 데이터베이스 재배포

```bash
# DB Deployer 태스크 실행
cf run-task cap-bookshop-db-deployer "npm start" --name db-deploy
```

## 트러블슈팅

### 1. PostgreSQL 연결 실패

```bash
# 서비스 상태 확인
cf service cap-bookshop-db

# 서비스 바인딩 확인
cf env cap-bookshop-srv

# 로그 확인
cf logs cap-bookshop-srv --recent
```

### 2. 빌드 실패

```bash
# gen 폴더 삭제 후 재빌드
rm -rf gen
npm run build
```

### 3. 메모리 부족

```bash
# 메모리 증가
cf scale cap-bookshop-srv -m 512M
```

### 4. 배포 중 오류

```bash
# 기존 배포 삭제 후 재배포
cf undeploy cap-bookshop --delete-services
cf deploy mta_archives/cap-bookshop_1.0.0.mtar
```

## BTP Cockpit에서 확인

1. SAP BTP Cockpit 접속
2. Subaccount > Cloud Foundry > Spaces > {your-space}
3. Applications 탭에서 `cap-bookshop-srv` 확인
4. Service Instances 탭에서 `cap-bookshop-db` 확인
5. Application Routes에서 애플리케이션 URL 확인

## 환경별 설정

### Development
```bash
cf target -s dev
cf deploy mta_archives/cap-bookshop_1.0.0.mtar
```

### Production
```bash
cf target -s prod
cf deploy mta_archives/cap-bookshop_1.0.0.mtar --strategy blue-green
```

## 참고 자료

- [SAP BTP PostgreSQL](https://help.sap.com/docs/postgresql-hyperscaler-option)
- [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/)
- [MTA Documentation](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/d04fc0e2ad894545aebfd7126384307c.html)
- [CAP Deployment](https://cap.cloud.sap/docs/guides/deployment/)
