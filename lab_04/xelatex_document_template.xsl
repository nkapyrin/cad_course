<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
<xsl:output method="text"/>

<xsl:param name="include_source_code" select="yes"/>

<!-- Основной шаблон, с которого начинается текст -->
<xsl:template match="/">

<xsl:text>
% !TeX program = xelatex

%%% Загружаем заголовочный файл, который хранит все настройки и все подгружаемые пакеты
\input{header.tex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ФИО авторов, название документов

%%% Название документа
\ESKDtitle{Программа MultiWii \par\vspace{.8cm}}

\ESKDdocName{Описание программы}

\ESKDauthor{Автор А.А.}
\ESKDchecker{Проверяющий Б.Б.}
\ESKDnormContr{Нормоконтроллёр В.В.}

%%% Для титульного листа
\ESKDtitleApprovedBy{ Должность утверждающего }{ Фам. утвер. }
%\ESKDtitleAgreedBy{ Должность первого согласовавшего }{ Фам. первого согл. }
%\ESKDtitleAgreedBy{ Должность второго согласовавшего }{ Фам. второго согл. }
%\ESKDtitleAgreedBy{ Должность третьего согласовавшего }{ Фам. третьего согл. }
\ESKDtitleDesignedBy{ </xsl:text><xsl:value-of select="/cx/@author1post"/><xsl:text> }{ </xsl:text><xsl:value-of select="/cx/@author1name"/><xsl:text> }
\ESKDtitleDesignedBy{ </xsl:text><xsl:value-of select="/cx/@author2post"/><xsl:text> }{ </xsl:text><xsl:value-of select="/cx/@author2name"/><xsl:text> }

%\ESKDdepartment{ Ведомство }
%\ESKDcompany{АО Компания}
%\ESKDclassCode{ Код по классификатору }
\ESKDsignature{\DecimalNumber}

\ESKDdate{ 2019/09/01 }
\renewcommand{\DecimalNumber}{АБВГ 12345-01 }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Особые настройки для основного документа
\input{eskdmaindoc.tex}


\begin{document}

%%% Оформляем титульный лист
\maketitle

\section*{Аннотация}

\addcontentsline{toc}{section}{Аннотация}

Настоящий документ содержит описание проекта...

В документе представлены сведения о назначении программы, её составе, структуре, языке программирования и описание алгоритма программы.

%%% Таблица содержания

\tableofcontents

\section*{Общие сведения}&#xa;&#xa;</xsl:text>

<xsl:text>Программа написана на языке С++ и работает на Arduino-совместимых платформах.&#xa;&#xa;</xsl:text>

<xsl:text>\section{Функциональное назначение}&#xa;&#xa;</xsl:text>

<xsl:text>Программа предназначена для управления квадрокоптером.&#xa;&#xa;</xsl:text>

<!--================= Индексы файлов, директорий, пространств имён =================-->

<xsl:text>\section{Описание логической структуры}&#xa;&#xa;</xsl:text>


<!-- Указатель файлов -->
<xsl:choose>
  <xsl:when test="count(//compounddef[@kind='file']) &gt; 0">
    <xsl:text>\subsection{Указатель файлов}&#xa;&#xa;</xsl:text>
    <xsl:for-each select="//compounddef[@kind='file']">
      <xsl:sort select="compoundname/text()"/>
      <xsl:text>\noindent\hyperref[</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>]{\nolinkurl{</xsl:text>
      <xsl:value-of select="compoundname/text()"/>
      <xsl:text>}}\dotfill\pageref{</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>}&#xa;&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:when>
</xsl:choose>


<!--=================== Описания объектов ===================-->



<!-- Описание файлов -->


<xsl:choose>
  <xsl:when test="count(//compounddef[@kind='file']) &gt; 0">
    <xsl:for-each select="///compounddef[@kind='file']">
      <xsl:sort select="compoundname/text()"/> <!-- Включать имена файлов в алфавитном порядке -->
      <xsl:variable name="this_file_refid" select="@id"/>

      <xsl:text>\subsection{Файл </xsl:text>
        <!-- Особые команды чтобы не сломать таблицу содержания в PDF командой nolinkurl -->
        <xsl:text>\texorpdfstring{</xsl:text>
        <xsl:text>\nolinkurl{</xsl:text><xsl:value-of select="compoundname/text()"/><xsl:text>}</xsl:text>
        <xsl:text>}{</xsl:text><xsl:value-of select="compoundname/text()"/><xsl:text>}</xsl:text>
      <xsl:text>}\label{</xsl:text><xsl:value-of select="@id"/><xsl:text>}&#xa;&#xa;</xsl:text>

      <!-- Директивы препроцессора -->
      <xsl:choose>
        <xsl:when test="count(sectiondef/memberdef[@kind='define']) &gt; 0">
          <xsl:text>\paragraph{Директивы препроцессора}\mbox{}&#xa;&#xa;</xsl:text>
          <xsl:for-each select="sectiondef/memberdef[@kind='define']">
            <xsl:text>\raggedright\noindent\#define </xsl:text>
            <xsl:value-of select="name/text()"/><xsl:text> </xsl:text><xsl:value-of select="initializer/@compiled_text"/>
            <xsl:text>\label{</xsl:text><xsl:value-of select="@id"/><xsl:text>}</xsl:text>
            <xsl:text>&#xa;&#xa;</xsl:text>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>

      <!-- Подключаемые модули -->
      <xsl:choose>
        <xsl:when test="count(includes) &gt; 0">
          <xsl:text>\paragraph{Подключаемые модули}\mbox{}&#xa;&#xa;</xsl:text>
          <xsl:for-each select="includes">
            <xsl:choose>
              <xsl:when test="@refid">
                <xsl:choose>
                  <xsl:when test="@local!='no'">
                    <xsl:text>\raggedright\noindent\#include "\hyperref[</xsl:text>
                    <xsl:value-of select="@refid"/><xsl:text>]{\nolinkurl{</xsl:text><xsl:value-of select="text()"/><xsl:text>}}"&#xa;&#xa;</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>\raggedright\noindent\#include &lt;\hyperref[</xsl:text>
                    <xsl:value-of select="@refid"/><xsl:text>]{\nolinkurl{</xsl:text><xsl:value-of select="text()"/><xsl:text>}}&gt;&#xa;&#xa;</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="@local!='no'">
                    <xsl:text>\raggedright\noindent\#include "\nolinkurl{</xsl:text><xsl:value-of select="text()"/><xsl:text>}"&#xa;&#xa;</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>\raggedright\noindent\#include &lt;\nolinkurl{</xsl:text><xsl:value-of select="text()"/><xsl:text>}&gt;&#xa;&#xa;</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <xsl:text>&#xa;&#xa;</xsl:text>
        </xsl:when>
      </xsl:choose>

      <!-- Классы -->
      <xsl:choose>
        <xsl:when test="count(innerclass) &gt; 0">
          <xsl:text>\paragraph{Классы}\mbox{}&#xa;&#xa;\begin{itemize}&#xa;</xsl:text>
          <xsl:for-each select="innerclass">
            <xsl:text>\item \hyperref[</xsl:text><xsl:value-of select="@refid"/>
            <xsl:text>]{</xsl:text><xsl:value-of select="text()"/><xsl:text>}\\</xsl:text>
            <xsl:text>&#xa;</xsl:text>
          </xsl:for-each>
          <xsl:text>\end{itemize}&#xa;&#xa;</xsl:text>
        </xsl:when>
      </xsl:choose>

      <xsl:if test="$include_source_code='yes'">
        <!-- Текст файла -->
        <xsl:choose>
          <xsl:when test="count(programlisting/codeline) &gt; 0">
            <xsl:text>\paragraph{Текст файла}\mbox{}&#xa;&#xa;</xsl:text>
            <xsl:text>Текст файла \nolinkurl{</xsl:text><xsl:value-of select="@full_path_name"/>
            <xsl:text>} приведён в листинге \ref{</xsl:text><xsl:value-of select="@refid"/><xsl:text>-code</xsl:text>
            <xsl:text>}.&#xa;&#xa;</xsl:text>
            <xsl:text>\begin{lstlisting}[</xsl:text>
            <xsl:text>label=</xsl:text>
            <xsl:value-of select="@refid"/><xsl:text>-code</xsl:text>
            <xsl:text>,caption={Текст файла </xsl:text>
            <xsl:value-of select="@full_path_name"/>
            <xsl:text>}]&#xa;&#xa;</xsl:text>
            <xsl:for-each select="programlisting/codeline">
            <xsl:apply-templates select="*|text()"/><xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
            <xsl:text>\end{lstlisting}&#xa;&#xa;</xsl:text>
            <xsl:text>&#xa;&#xa;</xsl:text>
          </xsl:when>
      </xsl:choose>
    </xsl:if>

    </xsl:for-each>
  </xsl:when>
</xsl:choose>


<xsl:text>\section{Вызов и загрузка}&#xa;&#xa;</xsl:text>
<xsl:text>...&#xa;&#xa;</xsl:text>


<xsl:text>&#xa;&#xa;\section{Входные данные}&#xa;&#xa;</xsl:text>
<xsl:text>...&#xa;&#xa;</xsl:text>


<xsl:text>&#xa;&#xa;\section{Выходные данные}&#xa;&#xa;</xsl:text>
<xsl:text>...&#xa;&#xa;</xsl:text>


<xsl:text>\begin{ESKDchangeSheet}
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\ \hline
 &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; &amp; \\
\end{ESKDchangeSheet}

\end{document}</xsl:text>
</xsl:template>



<xsl:template name="list_object_contents">
<!-- Открытые типы: public-type -->
      <xsl:for-each select="compounddef/sectiondef[@kind='public-type']">
        <xsl:text>\paragraph{Открытые типы}\mbox{}&#xa;&#xa;</xsl:text><xsl:call-template name="list_entities"/>
      </xsl:for-each>
<!-- Открытые члены: public-func -->
      <xsl:for-each select="compounddef/sectiondef[@kind='public-func']">
        <xsl:text>\paragraph{Открытые члены}\mbox{}&#xa;&#xa;</xsl:text><xsl:call-template name="list_entities"/>
      </xsl:for-each>
<!-- Открытые атрибуты: public-attrib, signal, protected-slot-->
      <xsl:choose>
        <xsl:when test="((count(compounddef/sectiondef[@kind='public-attrib' or @kind='signal' or @kind='protected-slot']) &gt; 0))">
          <xsl:text>\paragraph{Открытые атрибуты}\mbox{}&#xa;&#xa;\begin{itemize}&#xa;</xsl:text>
          <xsl:for-each select="compounddef/sectiondef[@kind='public-attrib']"><xsl:call-template name="entitiy_description"/></xsl:for-each>
          <xsl:for-each select="compounddef/sectiondef[@kind='signal']"><xsl:call-template name="entitiy_description"/></xsl:for-each>
          <xsl:for-each select="compounddef/sectiondef[@kind='protected-slot']"><xsl:call-template name="entitiy_description"/></xsl:for-each>
          <xsl:text>\end{itemize}&#xa;&#xa;</xsl:text>
        </xsl:when>
      </xsl:choose>
<!-- Закрытые данные: protected-attrib -->
      <xsl:for-each select="compounddef/sectiondef[@kind='private-attrib']">
        <xsl:text>\paragraph{Закрытые данные}\mbox{}&#xa;&#xa;</xsl:text><xsl:call-template name="list_entities"/>
      </xsl:for-each>
<!-- Закрытые функции: private-func, private-slot -->
      <xsl:choose>
        <xsl:when test="((count(compounddef/sectiondef[@kind='private-func' or @kind='private-slot']) &gt; 0))">
          <xsl:text>\paragraph{Закрытые функции}\mbox{}&#xa;&#xa;\begin{itemize}&#xa;</xsl:text>
          <xsl:for-each select="compounddef/sectiondef[@kind='private-func']"><xsl:call-template name="entitiy_description"/></xsl:for-each>
          <xsl:for-each select="compounddef/sectiondef[@kind='private-slot']"><xsl:call-template name="entitiy_description"/></xsl:for-each>
          <xsl:text>\end{itemize}&#xa;&#xa;</xsl:text>
        </xsl:when>
      </xsl:choose>
<!-- Закрытые статические данные: private-static-attrib -->
      <xsl:for-each select="compounddef/sectiondef[@kind='private-static-attrib']">
        <xsl:text>\paragraph{Закрытые статические данные}\mbox{}&#xa;&#xa;</xsl:text><xsl:call-template name="list_entities"/>
      </xsl:for-each>
<!-- Защищённые данные: protected-attrib -->
      <xsl:for-each select="compounddef/sectiondef[@kind='protected-attrib']">
        <xsl:text>\paragraph{Защищённые данные}\mbox{}&#xa;&#xa;</xsl:text><xsl:call-template name="list_entities"/>
      </xsl:for-each>
</xsl:template>



<!-- Добавление в документацию списка объектов -->
<xsl:template name="list_entities">
    <xsl:text>&#xa;&#xa;\begin{itemize}&#xa;</xsl:text>
    <xsl:call-template name="entitiy_description"/>
    <xsl:text>\end{itemize}&#xa;&#xa;</xsl:text>
</xsl:template>



<!-- Написание документации для одного метода или члена -->
<xsl:template name="entitiy_description">
    <xsl:for-each select="memberdef">
      <xsl:choose>
        <xsl:when test="@kind='enum'">
          <xsl:call-template name="one_enum_item"/>
        </xsl:when>
        <xsl:when test="@kind='typedef'">
          <xsl:call-template name="one_typedef_item"/>
        </xsl:when>
        <xsl:when test="@kind='variable'">
          <xsl:call-template name="one_variable_item"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="one_entity"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
</xsl:template>



<!-- Написание документации для одного объекта перечислимого типа -->
<xsl:template name="one_enum_item">
    <xsl:text>\item enum \hyperref[</xsl:text><xsl:value-of select="@id"/><xsl:text>]{</xsl:text>
    <xsl:value-of select="name/text()"/><xsl:value-of select="argsstring/text()"/>
    <xsl:text>} \{</xsl:text>
    <xsl:for-each select="enumvalue"><xsl:value-of select="name/text()"/><xsl:value-of select="initializer/text()"/><xsl:if test="position() != last()">, </xsl:if></xsl:for-each>
    <xsl:text>\}&#xa;</xsl:text>
</xsl:template>

<!-- Написание документации для одной переменной -->
<xsl:template name="one_variable_item">
    <xsl:text>\item \hyperref[</xsl:text><xsl:value-of select="@id"/>
    <xsl:text>]{</xsl:text>
    <xsl:value-of select="definition/text()"/><xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!-- Написание документации для одного определения типа -->
<xsl:template name="one_typedef_item">
    <xsl:text>\item \hyperref[</xsl:text><xsl:value-of select="@id"/><xsl:text>]{</xsl:text>
    <xsl:value-of select="definition/text()"/><xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!-- Написание документации для других объектов -->
<xsl:template name="one_entity">
    <xsl:text>\item \hyperref[</xsl:text><xsl:value-of select="@id"/><xsl:text>]{</xsl:text>
    <!--<xsl:if test="type/text()"><xsl:value-of select="type/text()"/><xsl:text> </xsl:text></xsl:if>-->
    <!--<xsl:value-of select="type/text()"/><xsl:text> </xsl:text>
    <xsl:value-of select="name/text()"/><xsl:value-of select="argsstring/text()"/>-->
    <xsl:value-of select="definition/text()"/>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>



<!-- Добавить локализацию определения файла -->
<xsl:template name="define_string">
  <xsl:if test="location">
    <xsl:text>См. определение в файле </xsl:text>
    <xsl:if test="location/@refid">
      <xsl:text>\hyperref[</xsl:text>
      <xsl:value-of select="location/@refid"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="location/@file"/>
    <xsl:text>}</xsl:text>
    <!--<xsl:text> строка </xsl:text>
    <xsl:value-of select="location/@line"/>-->
    <!--<xsl:text>\hyperref[</xsl:text>
    <xsl:value-of select="location/@refid"/><xsl:text>-code</xsl:text><xsl:value-of select="location/@line"/>
    <xsl:text>]</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="location/@line"/>
    <xsl:text>}</xsl:text>-->
    <xsl:text> строка ~\lstlinelink{</xsl:text><xsl:value-of select="location/@refid"/><xsl:text>-code</xsl:text>
    <xsl:text>}{</xsl:text><xsl:value-of select="location/@line"/>
    <xsl:text>}</xsl:text>
    <xsl:text>.&#xa;&#xa;</xsl:text>
  </xsl:if>
</xsl:template>



<xsl:template name="describe_enum">
  <xsl:text>\paragraph{enum \hyperref[</xsl:text><xsl:value-of select="@id"/>
  <xsl:text>]{</xsl:text><xsl:value-of select="name/text()"/><xsl:value-of select="argsstring/text()"/>
  <xsl:text>}} \{</xsl:text>
  <xsl:for-each select="enumvalue"><xsl:value-of select="name/text()"/><xsl:value-of select="initializer/text()"/>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}</xsl:text>
  <xsl:if test="position() != last()">, </xsl:if></xsl:for-each>
  <xsl:text>\}</xsl:text>
  <xsl:text>\mbox{}</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:call-template name="define_string"/>
</xsl:template>



<!-- Добавить определение методу, конструктору или деструктору -->
<xsl:template name="describe_method">
  <xsl:text>\paragraph{</xsl:text><xsl:value-of select="definition/text()"/>
  <xsl:value-of select="argsstring/text()"/>
  <xsl:text>}</xsl:text>
  <xsl:text>\label{</xsl:text><xsl:value-of select="@id"/><xsl:text>}</xsl:text>
  <xsl:if test="((@static='yes')or(@inline='yes'))">
    <xsl:text>\texttt{[</xsl:text>
    <xsl:if test="(@static='yes')">static</xsl:if>
    <xsl:if test="((@static='yes')and(@inline='yes'))"><xsl:text>, </xsl:text></xsl:if>
    <xsl:if test="(@inline='yes')">inline</xsl:if>
    <xsl:text>]}</xsl:text>
  </xsl:if>
  <xsl:text>\mbox{}</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:call-template name="define_string"/>
  <xsl:if test="references"><xsl:text>Перекрёстные ссылки: </xsl:text><xsl:for-each select="references">
    <xsl:text>\hyperref[</xsl:text><xsl:value-of select="@refid"/>
    <xsl:text>]{</xsl:text><xsl:value-of select="text()"/><xsl:text>}</xsl:text>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each><xsl:text>.&#xa;&#xa;</xsl:text></xsl:if>
  <xsl:if test="referencedby"><xsl:text>Используется в </xsl:text><xsl:for-each select="referencedby">
    <xsl:text>\hyperref[</xsl:text><xsl:value-of select="@refid"/>
    <xsl:text>]{</xsl:text><xsl:value-of select="text()"/><xsl:text>}</xsl:text>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each><xsl:text>.&#xa;&#xa;</xsl:text></xsl:if>
</xsl:template>


<xsl:template match="sp"><xsl:text> </xsl:text></xsl:template>
<xsl:template match="text()">
  <xsl:value-of select="."/>
  <xsl:apply-templates select="*|text()"/>
</xsl:template>



</xsl:stylesheet>
