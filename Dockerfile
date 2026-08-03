FROM docker.io/tobix/wine:stable

ARG USERNAME=runner
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY *.dll *.exe /home/runner

RUN --mount=type=bind,target=/src <<EOF
unzip /src/cv2pdb-0.54.zip -d /home/runner
EOF

USER $USERNAME

ENV WINEDEBUG=-all

RUN winecfg /h 2>/dev/null

WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
