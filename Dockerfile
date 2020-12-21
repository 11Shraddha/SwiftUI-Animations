# This file is a template, and might need editing before it works on your project.
FROM swift:5.0 as builder

WORKDIR /src
COPY . .
RUN swift build -c release

FROM swift:5.0-slim

WORKDIR /src
COPY --from=builder /src .
EXPOSE 8080

CMD [ ".build/release/app"]
