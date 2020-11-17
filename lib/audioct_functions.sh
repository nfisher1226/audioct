#  audioct_functions.sh
#  
#  Copyright 2020 Nathan Fisher <nfisher.sr@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

function convert_f2m {
  flac="$@"
  tmp=$(mktemp)
  metaflac --export-tags-to=- "${flac}" | sed -e 's/\=/\=\"/g' \
    -e 's/$/\"/g' -e 's:\/:_:g' -e 's:?:_:g' | \
    egrep 'TITLE|ARTIST|ALBUM|GENRE|TRACKNUMBER|DATE' \
    | egrep -v 'ALBUM ARTIST|RELEASE DATE' > ${tmp}
  . $tmp
  # Make sure the tag fields aren't empty
  [ "${TITLE}" = "" ] && TITLE="$(basename \"${flac}\" .flac)"
  [ "${ARTIST}" = "" ] && ARTIST=UNKNOWN
  [ "${ALBUM}" = "" ] && ALBUM=UNKNOWN
  [ "${GENRE}" = "" ] && GENRE=Rock
  [ "${TRACKNUMBER}" = "" ] && TRACKNUMBER=00
  [ "${DATE}" = "" ] && DATE=1900
  flac -cds "${flac}" | lame -S --preset ${lame_preset} --tt "${TITLE}" \
    --ta "${ARTIST}" --tl "${ALBUM}" --ty "${DATE}" --tn \
    "${TRACKNUMBER}/${TTN}" --tg "${GENRE}" - \
    "${TRACKNUMBER} - ${TITLE}.mp3" && \
  [ "$remove_source" = "true" ] && rm -rf "${flac}" || true
  rm $tmp
}

function convert_f2o {
  flac="$@"
  tmp=$(mktemp)
  metaflac --export-tags-to=- "${flac}" | sed -e 's/\=/\=\"/g' \
    -e 's/$/\"/g' -e 's:\/:_:g' -e 's:?:_:g' | \
    egrep 'TITLE|ARTIST|ALBUM|GENRE|TRACKNUMBER|DATE' \
    | egrep -v 'ALBUM ARTIST|RELEASE DATE' > ${tmp}
  . $tmp
  # Make sure the tag fields aren't empty
  [ "${TITLE}" = "" ] && TITLE="$(basename \"${flac}\" .flac)"
  [ "${ARTIST}" = "" ] && ARTIST=UNKNOWN
  [ "${ALBUM}" = "" ] && ALBUM=UNKNOWN
  [ "${GENRE}" = "" ] && GENRE=Rock
  [ "${TRACKNUMBER}" = "" ] && TRACKNUMBER=00
  [ "${DATE}" = "" ] && DATE=1900
  flac -cds "${flac}" | oggenc -Q -q ${ogg_quality} -t "${TITLE}" -a "${ARTIST}" \
    -l "${ALBUM}" -d "${DATE}" -N "${TRACKNUMBER}/${TTN}" -G "${GENRE}" \
    -o "${TRACKNUMBER} - ${TITLE}.ogg" - && \
  [ "$remove_source" = "true" ] && rm -rf "${flac}" || true
  rm $tmp
}

function convert_m42m {
  m4a="$@"
  TITLE="$(basename "${m4a}" .m4a | cut -f 3- -d ' ')"
  TRACKNUMBER="$(cut -f 1 -d ' '<<<${m4a})"
  faad -q --stdio "${m4a}" | lame -S --preset ${lame_preset} --tt "${TITLE}" \
    --tn "${TRACKNUMBER}/${TTN}" --tl "${ALBUM}" \
    --ta "${ARTIST}" --ty "${DATE}" --tg "${GENRE}" - \
    "${TRACKNUMBER} - ${TITLE}.mp3" && \
  [ "$remove_source" = "true" ] && rm -rf "${m4a}" || true
}

function convert_w2m {
  wav="$@"
  TITLE="$(basename "${wav}" .wav | cut -f 3- -d ' ')"
  TRACKNUMBER="$(cut -f 1 -d ' '<<<${wav})"
  lame -S --preset ${lame_preset} --tt "${TITLE}" \
    --tn "${TRACKNUMBER}/${TTN}" --tl "${ALBUM}" \
    --ta "${ARTIST}" --ty "${DATE}" --tg "${GENRE}" "${wav}" \
    "${TRACKNUMBER} - ${TITLE}.mp3" && \
  [ "$remove_source" = "true" ] && rm -rf "${wav}" || true
}

function convert_w2o {
  wav="$@"
  TITLE="$(basename "${wav}" .wav | cut -f 3- -d ' ')"
  TRACKNUMBER="$(cut -f 1 -d ' '<<<${wav})"
  oggenc -Q -q ${ogg_quality} -t "${TITLE}" -a "${ARTIST}" \
    -l "${ALBUM}" -d "${DATE}" -N "${TRACKNUMBER}/${TTN}" -G "${GENRE}" \
    -o "${TRACKNUMBER} - ${TITLE}.ogg" "${wav}" && \
  [ "$remove_source" = "true" ] && rm -rf "${wav}" || true
}

function convert_w2f {
  wav="$@"
  name="$(basename "${wav}" .wav)"
  TN="$(cut -f 1 -d ' ' <<< $name)"
  TT="$(cut -f 3- -d ' ' <<< $name)"
  flac ${flac_compression} --tag="TITLE=${TT}" --tag="TRACKNUMBER=${TN}" \
    --tag="TOTALTRACKS=${TTN}" --tag="ALBUM=${TL}" --tag="ARTIST=${TA}" \
    --tag="DATE=${TY}" --tag="GENRE=${TG}" "${wav}" && \
  [ "$remove_source" = "true" ] && rm -rf "${wav}" || true
}
