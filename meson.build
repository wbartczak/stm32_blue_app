project('blue_app', ['c', 'cpp'],
        version: '1.0')

blue_app_sources = ['startup.S', 'main.c']

blue_app_link_args = ['-gdwarf-4',
                      '-Wl,--gc-sections',
                      '-Wl,-T,@0@/@1@'.format(meson.current_source_dir(), 'link_f103c8.ld')
]

executable('blue_app', blue_app_sources,
           c_args : ['-O2', '-gdwarf-4'],
           link_args : blue_app_link_args)