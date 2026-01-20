FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY . .
RUN apk update
RUN apk add upx
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -trimpath -o /action ./cmd/action/main.go
RUN upx --best /action

FROM alpine:3.23.2
COPY --from=builder /action /action
