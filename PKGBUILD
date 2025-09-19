# Maintainer: ghazzor <kartikhis8o@gmail.com>
download() {
  OWNER="ghazzor"
  REPO="firefox-builder"
  RELEASE_JSON=$(curl -s "https://api.github.com/repos/${OWNER}/${REPO}/releases/latest")

  ASSET_URL=$(echo "${RELEASE_JSON}" | jq -r '.assets[].browser_download_url' | grep 'tar.xz$')
  TARBALL_NAME=$(basename "$ASSET_URL")
  export FIREFOX_DIR="bin/firefox"

  # Extract version
  export ver=$(echo "${RELEASE_JSON}" | jq -r '.tag_name' | cut -f2 -d'-' | cut -f2 -d'v')

  echo "$ASSET_URL"
  echo $PWD

  if [[ ! -f "$TARBALL_NAME" ]]; then
    rm -rf *.tar.xz
    aria2c ${ASSET_URL}
  fi
  [[ ! -d "$FIREFOX_DIR" ]] && mkdir -p bin && tar -xvf "$TARBALL_NAME" -C bin
}

download
pkgname=firefox-lp3
pkgver=$(echo $ver)
pkgrel=1
pkgdesc='Unofficial Firefox build for x86-64-v3 CPU with O3+LTO+PGO'
arch=('x86_64')
url=""
touch firefox.install
install=firefox.install

package() {
  cd ..
  mkdir -p "${pkgdir}/opt/"
  cp -r "$FIREFOX_DIR" "${pkgdir}/opt/"
  mv "${pkgdir}/opt/firefox/firefox" "${pkgdir}/opt/firefox/$pkgname"
  mv "${pkgdir}/opt/firefox/firefox-bin" "${pkgdir}/opt/firefox/$pkgname-bin"
  mv "${pkgdir}/opt/firefox" "${pkgdir}/opt/$pkgname"
  mkdir -p "${pkgdir}/usr/share/applications/"
  curl https://raw.githubusercontent.com/ghazzor/firefox-builder/refs/heads/main/firefox-lp3.desktop > "${pkgdir}/usr/share/applications/$pkgname.desktop"
  cat << EOF > firefox.install
post_install() {
ln -s /opt/firefox-lp3/firefox-lp3 /usr/bin/firefox-lp3
}

post_upgrade() {
  rm -rf /usr/bin/firefox-lp3
  post_install
}

post_remove() {
  rm -rf /usr/bin/firefox-lp3
}
EOF

  rm -rf "$FIREFOX_DIR"
}
