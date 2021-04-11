Describe "dotenv python parser"
  parse_env() {
    [ $# -gt 1 ] || set -- "$1" -v OVERLOAD=1
    %putsn "$1" | ( shift; awk -f ./src/parser.awk -v DIALECT="python" "$@" )
  }

  Context "when the key is given"
    Describe
      Parameters
        '  FOO=bar'                 "FOO='bar'"
        'FOO  =bar'                 "FOO='bar'"
      End

      It "parses value the \`$1'"
        When call parse_env "$1"
        The output should eq "$2"
      End
    End
  End

  Context "when the double quoted value is given"
    Before "export VAR=123"

    Describe
      Parameters
        'VALUE="foo\abar"'        "VALUE='foo${BEL}bar'"
        'VALUE="foo\bbar"'        "VALUE='foo${BS}bar'"
        'VALUE="foo\fbar"'        "VALUE='foo${FF}bar'"
        'VALUE="foo\nbar"'        "VALUE='foo${LF}bar'"
        'VALUE="foo\rbar"'        "VALUE='foo${CR}bar'"
        'VALUE="foo\tbar"'        "VALUE='foo${HT}bar'"
        'VALUE="foo\vbar"'        "VALUE='foo${VT}bar'"
        'VALUE="foo\zbar"'        "VALUE='foo\zbar'"
        'FOO="${VAR}"'            "FOO='123'"
      End

      It "parses value the \`$1'"
        When call parse_env "$1"
        The output should eq "$2"
      End
    End
  End
End
