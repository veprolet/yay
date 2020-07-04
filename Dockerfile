FROM lopsided/archlinux:devel AS test_image

LABEL maintainer="Jguer,joaogg3 at google mail"

WORKDIR /app

RUN pacman -Syu --overwrite=* --needed --noconfirm \
    go git

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

CMD ["make", "test_lint"]

FROM test_image AS builder

RUN make build

# ------------------------------------------------------------------------------
# Production image
# ------------------------------------------------------------------------------
FROM lopsided/archlinux:latest as prod_img
COPY --from=builder /app/yay yay

ENTRYPOINT [ "./yay" ]
