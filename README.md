# CI/CD Demo Project

Jenkins + Docker + Kubernetes를 통한 완전한 CI/CD 파이프라인 데모 프로젝트입니다.

## 프로젝트 구성

- `server.js`: Express.js 웹 서버 (보안 미들웨어, 헬스체크 포함)
- `package.json`: Node.js 프로젝트 설정 및 의존성
- `public/index.html`: 동적 웹페이지 (API 연동)
- `Dockerfile`: 멀티스테이지 Docker 빌드 설정 (보안 강화)
- `.dockerignore`: Docker 빌드 제외 파일 설정
- `k8s/`: Kubernetes 배포 매니페스트
  - `deployment.yaml`: 애플리케이션 배포 설정
  - `service.yaml`: 서비스 노출 설정
  - `ingress.yaml`: 외부 접근 설정
- `README.md`: 프로젝트 설명서

## 기술 스택

- **Backend**: Node.js + Express.js
- **Frontend**: Vanilla JavaScript + CSS3
- **Container**: Docker (멀티스테이지 빌드)
- **Orchestration**: Kubernetes
- **CI/CD**: Jenkins Pipeline

## 로컬 실행 방법

### 1. 의존성 설치
```bash
npm install
```

### 2. 개발 서버 실행
```bash
npm run dev
```

### 3. 프로덕션 서버 실행
```bash
npm start
```

## Docker 빌드 및 실행

### 1. Docker 이미지 빌드
```bash
docker build -t cicd-demo:latest .
```

### 2. 컨테이너 실행
```bash
docker run -p 3000:3000 -e APP_VERSION=1.0.0 -e BUILD_NUMBER=#001 cicd-demo:latest
```

### 3. 멀티스테이지 빌드 확인
```bash
# 빌드 과정에서 각 스테이지 확인
docker build --progress=plain -t cicd-demo:latest .
```

## Kubernetes 배포

### 1. 네임스페이스 및 배포 생성
```bash
kubectl apply -f k8s/deployment.yaml
```

### 2. 서비스 노출
```bash
kubectl apply -f k8s/service.yaml
```

### 3. Ingress 설정 (외부 접근)
```bash
kubectl apply -f k8s/ingress.yaml
```

### 4. 배포 상태 확인
```bash
# 파드 상태 확인
kubectl get pods -n cicd-demo

# 서비스 확인
kubectl get svc -n cicd-demo

# Ingress 확인
kubectl get ingress -n cicd-demo

# 로그 확인
kubectl logs -f deployment/cicd-demo-deployment -n cicd-demo
```

### 5. 애플리케이션 접근
- 클러스터 내부: `http://cicd-demo-service.cicd-demo.svc.cluster.local`
- 외부 접근: `http://demo.cicd.lab` (Ingress 설정 후)

## CI/CD 파이프라인 테스트

### 수정 가능한 요소들:
- **서버 코드**: `server.js`의 버전, 빌드 번호, 환경 변수
- **프론트엔드**: `public/index.html`의 타이틀, 스타일
- **Docker 설정**: `Dockerfile`의 Node.js 버전, 포트 설정
- **Kubernetes 설정**: `k8s/` 디렉토리의 배포 매니페스트
- **패키지 설정**: `package.json`의 버전, 의존성

### 테스트 시나리오:
1. 코드 수정 후 Git 커밋
2. Jenkins 파이프라인 자동 실행
3. Docker 멀티스테이지 빌드 진행
4. Docker 이미지 레지스트리 푸시
5. Kubernetes 클러스터에 자동 배포
6. 웹페이지 확인 및 헬스체크 검증

## API 엔드포인트

- `GET /`: 메인 웹페이지
- `GET /api/health`: 서버 상태 확인
- `GET /api/info`: 애플리케이션 정보 (버전, 빌드 번호 등)

## 보안 기능

- **Helmet**: 보안 헤더 설정 (CSP, XSS 보호 등)
- **CORS**: Cross-Origin Resource Sharing 설정
- **Non-root 사용자**: Docker 컨테이너에서 보안을 위한 비루트 사용자 실행
- **헬스체크**: Docker 및 Kubernetes 헬스체크 지원

## 환경 변수

- `NODE_ENV`: 실행 환경 (development/production)
- `PORT`: 서버 포트 (기본값: 3000)
- `APP_VERSION`: 애플리케이션 버전
- `BUILD_NUMBER`: 빌드 번호

## 모니터링 및 디버깅

### 헬스체크 엔드포인트
- `GET /api/health`: 서버 상태 및 업타임 확인
- `GET /api/info`: 애플리케이션 상세 정보 (버전, 빌드 번호, 환경 등)

### 로그 확인
```bash
# Docker 컨테이너 로그
docker logs <container_id>

# Kubernetes 파드 로그
kubectl logs -f deployment/cicd-demo-deployment -n cicd-demo
```
