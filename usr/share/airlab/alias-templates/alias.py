#!/usr/bin/env python3
# @desc: ONE-LINE description of what this alias does (shown by 'airlab a')
# @author: {{AUTHOR}}
#
# airlab alias: {{NAME}}
# Run as:  airlab a {{NAME}}
#
# Runs locally, in the caller's PWD, with airlab.env + the airlab venv active.
# Available via os.environ: AIRLAB_ALIAS_SELF, AIRLAB_ALIAS_DIR, AIRLAB_ALIAS_NAME.
# Note: v1 forwards no arguments except --help.

import os
import sys

HELP = """\
Usage: airlab a {{NAME}}

<Describe what this alias does, and any prerequisites.>
"""


def main() -> int:
    if len(sys.argv) > 1 and sys.argv[1] in ("-h", "--help"):
        print(HELP)
        return 0

    # ---- your logic below ----
    print("TODO: implement the {{NAME}} alias")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
