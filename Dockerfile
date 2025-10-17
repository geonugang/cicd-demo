# 멀티스테이지 빌드 Dockerfile
# Stage 1: Build stage
FROM node:18-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# 패키지 파일 복사
COPY package*.json ./

# 의존성 설치 (개발 의존성 포함)
RUN npm install --omit=dev && npm cache clean --force

# 소스 코드 복사
COPY . .

# 빌드 스크립트 실행 (필요시)
RUN npm run build

# Stage 2: Production stage
FROM node:18-alpine AS production

# 보안을 위한 non-root 사용자 생성
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# 작업 디렉토리 설정
WORKDIR /app

# 패키지 파일만 먼저 복사 (캐시 최적화)
COPY package*.json ./

# 프로덕션 의존성만 설치
RUN npm install --omit=dev && npm cache clean --force

# 빌드된 파일들을 builder stage에서 복사
COPY --from=builder --chown=nextjs:nodejs /app/server.js ./
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# 사용자 변경
USER nextjs

# 포트 노출
EXPOSE 3000

# 환경 변수 설정
ENV NODE_ENV=production
ENV PORT=3000

# 헬스체크 추가
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://127.0.0.1:3000/api/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# 애플리케이션 실행
CMD ["node", "server.js"]
