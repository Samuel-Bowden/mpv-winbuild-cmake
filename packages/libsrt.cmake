ExternalProject_Add(libsrt
    DEPENDS
        openssl
    GIT_REPOSITORY https://github.com/Haivision/srt.git
    GIT_TAG a8c6b65520f814c5bd8f801be48c33ceece7c4a6 # 1.5.4
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=ON
        -DENABLE_STDCXX_SYNC=ON
        -DENABLE_APPS=OFF
        -DENABLE_STATIC=OFF
        -DENABLE_SHARED=ON
        -DUSE_ENCLIB=openssl
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(libsrt copy-binary
    DEPENDEES libsrt install
    COMMAND ${CMAKE_COMMAND} -E copy <BINARY_DIR>/libsrt.dll          ${CMAKE_CURRENT_BINARY_DIR}/mpv-dev/libsrt.dll
    COMMENT "Copying srt binary"
)

force_rebuild_git(libsrt)
cleanup(libsrt copy-binary)
