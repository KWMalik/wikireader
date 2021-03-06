# Copyright (c) 2009 Openmoko Inc.
#
# Authors   Daniel Mack <daniel@caiaq.de>
#           Holger Hans Peter Freyther <zecke@openmoko.org>
#           Christopher Hall <hsw@openmoko.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

CFLAGS += -Wall -Werror -I. -gstabs -mlong-calls -fno-builtin -Os -mc33pe $(INCLUDES)
ASFLAGS = -mc33pe --fatal-warnings

# protection in case some Makefile includes this too early
.PHONY: this-is-included-too-early
this-is-included-too-early:
	@echo This is rules.mk reporting an error
	@echo move the '"include"' to the bottom of the Makefile.
	@echo Otherwise the dependencies are not built in the correct order
	@exit 1

# just so that all the REQUIRED_xxx can be evaluated
.PHONY: requires
	true

# some debugging rules

# use this like: 'make print-PATH print-CFLAGS' to see the value of make variable PATH and CFLAGS
print-%:
	@echo $* is $($*)


# compilation rules
%.o: %.c
	$(GCC) -MM $(CFLAGS) -MT $@ $< > ${@:.o=.d}
	$(GCC) -E $(CFLAGS) $< > ${@:.o=.p}
	$(GCC) $(CFLAGS) -c -o $@ -Wa,-ahl=${@:.o=.asm33} $<

${BUILD_PREFIX}%.o: %.c
	$(GCC) -MM $(CFLAGS) -MT $@ $< > ${@:.o=.d}
	$(GCC) -E $(CFLAGS) $< > ${@:.o=.p}
	$(GCC) $(CFLAGS) -c -o $@ -Wa,-ahl=${@:.o=.asm33} $<

%.o: %.s
	${AS} -o $@ ${ASFLAGS} -ahlsm=${@:.o=.lst} $<

${BUILD_PREFIX}%.o: %.s
	${AS} -o $@ ${ASFLAGS} -ahlsm=${@:.o=.lst} $<


# convert XPM to binary ICO format
%.ico: %.xpm
	${GRIFO_SCRIPTS}/xpm2icon --icon="$@" "$<"

# convert PNG to C header file
%.h: %.png ${IMAGE2HEADER}
	${IMAGE2HEADER} --inverted --header-file="$@" --variable-name="$(notdir ${@:.h=_image})" "$<"

${BUILD_PREFIX}%.h: %.png ${IMAGE2HEADER}
	${IMAGE2HEADER} --inverted --header-file="$@" --variable-name="$(notdir ${@:.h=_image})" "$<"


-include $(wildcard *.d) dummy
-include $(wildcard ${BUILD_PREFIX}*.d) dummy
