
# AUR:
make all doc html
make prefix=/usr DESTDIR="$pkgdir" install{,-doc,-html}

# RPM:
%prep
%setup -q
%if 0%{?python3}
# fix #!/usr/bin/env python to #!/usr/bin/env python3 everywhere
find . -type f -exec sh -c "head {} -n 1 | grep ^#\!\ \*/usr/bin/env\ python >/dev/null && sed -i -e sX^#\!\ \*/usr/bin/env\ python\ \*"\\\$"X#\!/usr/bin/env\ python3Xg {}" \;
%endif

%build
%global makeopts PYTHON="%{__python}" %{?sphinxbuild:SPHINXBUILD="%{sphinxbuild}"}
make %{?_smp_mflags} %{makeopts}
make %{makeopts} doc

%install
make DESTDIR=%{buildroot} prefix=%{_prefix} %{makeopts} install
make DESTDIR=%{buildroot} prefix=%{_prefix} %{makeopts} install-doc
make DESTDIR=%{buildroot} prefix=%{_prefix} %{makeopts} install-html
%find_lang %{name}

