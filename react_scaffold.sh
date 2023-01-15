#!/usr/bin/bash

# Languages
declare -r JS="js"
declare -r JSX="jsx"
declare -r TS="ts"
declare -r TSX="tsx"
declare -r LANGUAGES=($JS $TS)

# Styles
declare -r CSS="css"
declare -r SASS="sass"
declare -r SCSS="scss"
declare -r STYLED="styled"
declare -r STYLES=($CSS $SASS $SCSS $STYLED)

# Names
declare -r COMPONENT="component"
declare -r PAGE="page"
declare -r STYLE="styles"
declare -r NAMES=($COMPONENT $PAGE $STYLE)

#Colors
declare -r redColor="\e[0;31m\033[1m"
declare -r blueColor="\e[0;34m\033[1m"
declare -r yellowColor="\e[0;33m\033[1m"
declare -r greenColor="\e[0;32m\033[1m"
declare -r purpleColor="\e[0;35m\033[1m"
declare -r turquoiseColor="\e[0;36m\033[1m"
declare -r whiteColor="\e[0;37m\033[1m"
declare -r endColor="\033[0m\e[0m"

# Default values
language=$TS
component_language=$TSX
style=$STYLED
component=$COMPONENT

# Flag booleans
component_flag=false
page_flag=false
style_flag=false

function show_help() {
  echo -e "\n${redColor}[*]${endColor} ${whiteColor}Uso del script:${endColor} ${yellowColor}component.sh [flags] [nombres]${endColor}"
  echo -e "\n${redColor}[*]${endColor} ${whiteColor}Flags:${endColor}"
  echo -e "  ${yellowColor}-c | --component:${endColor}  ${whiteColor}Crea un componente${endColor}"
  echo -e "  ${yellowColor}-p | --page:${endColor}       ${whiteColor}Crea un componente tipo pagina${endColor}"
  echo -e "  ${yellowColor}-s | --styles:${endColor}     ${whiteColor}Selecciona el archivo de estilos${endColor}"
  echo -e "  ${yellowColor}-l | --language:${endColor}   ${whiteColor}Selecciona el lenguaje${endColor}"
  echo -e "  ${yellowColor}-h | --help:${endColor}       ${whiteColor}Muestra este mensaje de ayuda${endColor}"
  echo -e "\n${redColor}[*]${endColor} ${whiteColor}Valores validos para las flags:${endColor}"
  echo -e "  ${yellowColor}-s | --styles:${endColor}     ${whiteColor}${STYLES[*]}${endColor}"
  echo -e "  ${yellowColor}-l | --language:${endColor}   ${whiteColor}${LANGUAGES[*]}${endColor}"
  echo -e "\n${redColor}[*]${endColor} ${whiteColor}Posibles conflictos:${endColor}"
  echo -e "  ${yellowColor}-c | --component${endColor} ${whiteColor}y${endColor} ${yellowColor}-p | --page${endColor} ${whiteColor}no pueden ser usadas al mismo tiempo${endColor}"
}

function is_flag_in_array() {
  local array=("${@:1:$#-2}")
  local flag=("${@: -2:1}")
  local value=${@: -1:1}
  for element in ${array[@]}; do
    if [[ $element == $value ]]; then return 0; fi
  done
  echo -e "\n${redColor}[!]${endColor} ${whiteColor}Valor invalido para la flag:${endColor} ${purpleColor}\"$flag $value\"${endColor}"
  show_help
  exit 1
}

function flag_setted() {
  local value=$1
  local flag=$2
  if [[ $value == true ]]; then
    echo -e "\n${redColor}[!]${endColor} ${whiteColor}La flag${endColor} ${purpleColor}\"$flag\"${endColor} ${whiteColor}ya fue configurada${endColor}"
    show_help
    exit 1
  fi
}

function flag_conflict() {
  local value=$1
  local flag_1=$2
  local flag_2=$3
  if [[ $value == true ]]; then
    echo -e "\n${redColor}[!]${endColor} ${whiteColor}Las flags${endColor} ${purpleColor}\"$flag_1\"${endColor} y${endColor} ${purpleColor}\"$flag_2\"${endColor} ${whiteColor}no pueden ser usadas al mismo tiempo${endColor}"
    show_help
    exit 1
  fi
}

# Check if there are no arguments
if [[ $# -eq 0 ]]; then
  show_help
  exit 1
fi

# Temp arguments
temp_args=()

# Parse arguments
for arg in "$@"; do
  if [[ $arg == --* ]]; then
    short_arg=${arg:1:2}
    temp_args+=($short_arg)
  else
    temp_args+=($arg)
  fi
done

set -- "${temp_args[@]}"

while getopts ":cl:ps:h" opt; do
  case $opt in
    c)
      flag_conflict $page_flag "-c | --component" "-p | --page"
      flag_setted $component_flag "-c | --component"
      component_flag=true
      component=$COMPONENT
      ;;
    p)
      flag_conflict $component_flag "-p | --page" "-c | --component" 
      flag_setted $page_flag "-p | --page"
      page_flag=true
      component=$PAGE
      ;;
    s)
      is_flag_in_array ${STYLES[*]} "-s | --styles" $OPTARG
      flag_setted $style_flag "-s | --styles"
      style_flag=true
      style=$OPTARG
      ;;
    l)
      is_flag_in_array ${LANGUAGES[*]} "-l | --language" $OPTARG
      flag_setted $language_flag "-l | --language"
      language_flag=true
      language=$OPTARG
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo -e "\n${redColor}[!]${endColor} ${whiteColor}Flag invalida:${endColor} ${purpleColor}-$OPTARG${endColor}" >&2
      show_help
      exit 1
      ;;
    :)
      echo -e "\n${redColor}[!]${endColor} ${whiteColor}La flag${endColor} ${purpleColor}-$OPTARG${endColor} ${whiteColor}requiere un argumento${endColor}" >&2
      show_help
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

folder=$(find . -type d -name "${component}s")
if [[ $folder == "" ]]; then folder="."; fi

if [[ $language == $JS ]]; then component_language=$JSX
elif [[ $language == $TS ]]; then component_language=$TSX
fi

if [[ $style == $STYLED ]]; then style_language=$language
else style_language=$style; fi

function scaffold_index() {
  local name=$1
  local component=$2
  local index_file=$3
  local style=$4
  echo -e "export * from './$name.$component';" > "$index_file"
  if [[ $style == $STYLED ]]; then echo -e "export * as ${name}Styles from './$name.$STYLE'" >> "$index_file"; fi
}

function scaffold_styles() {
  local name=$1
  local styles_file=$2
  local style=$3
  if [[ $style == $STYLED ]]; then
    echo -e "import styled from 'styled-components';" > "$styles_file"
    echo -e "\nexport const ${name} = styled.div\`\`;" >> "$styles_file"
  fi
}

function scaffold_component() {
  local name=$1
  local component_file=$2
  local language=$3
  local style=$4

  # React import
  if [[ $language == $TS ]]; then echo -e "import { FC, ReactElement } from 'react';" > "$component_file"; fi
  
  # Styles import
  if [[ $style == $STYLED ]]; then echo -e "import * as S from './$name.$STYLE';\n" >> "$component_file";
  else echo -e "import './$name.$STYLE.$style';\n" >> "$component_file"; fi

  # Component declaration
  if [[ $language == $JS ]]; then echo -e "export const $name = () => {" >> "$component_file";
  elif [[ $language == $TS ]]; then echo -e "export const $name: FC = (): ReactElement => {" >> "$component_file"; fi

  # Component return
  if [[ $style == $STYLED ]]; then echo -e "\treturn <S.$name></S.$name>;" >> "$component_file";
  else echo -e "\treturn <div></div>;" >> "$component_file"; fi

  # Component closing
  echo -e "}" >> "$component_file"
}

# Generate components
for name in "$@"; do
  echo -e "\n${redColor}[+]${endColor} ${whiteColor}Generando componente:${endColor} ${purpleColor}$name${endColor}"
  component_folder="$folder/$name"
  component_file="$component_folder/$name.$component.$component_language"
  styles_file="$component_folder/$name.$STYLE.$style_language"
  index_file="$component_folder/index.$language"

  mkdir -p "$component_folder"
  touch "$component_file" "$styles_file" "$index_file"
  
  echo -e "${redColor}[+]${endColor} ${whiteColor}Armado de componente:${endColor} ${purpleColor}$name${endColor}"
  scaffold_index $name $component $index_file $style
  scaffold_styles $name $styles_file $style
  scaffold_component $name $component_file $language $style
done
