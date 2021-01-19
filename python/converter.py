import csv
from io import StringIO

from SPARQLWrapper import SPARQLWrapper, CSV

print("SNIK Query-to-.cmqf-Converter")
print("by Max Wächtler")
print("")
# Kopfzeile

endpoint = 'https://snik.eu/sparql'
s = SPARQLWrapper("https://snik.eu/sparql")
s.setReturnFormat(CSV)
# Endpunkt, der für die Ausführung der Queries genutzt wird -> SPARQL-Endpunkt bei SNIK

q = [
    'SELECT ?cDef ?corrAns ?d1 ?d2 ?d3 ?class { ?class rdfs:label ?corrAns. FILTER(LANGMATCHES(LANG(?corrAns),"en")) { SELECT ?class SAMPLE(str(?AnswDefinition)) as ?cDef SAMPLE(str(?dist1l)) as ?d1 SAMPLE(str(?dist2l)) as ?d2 SAMPLE(str(?dist3l)) as ?d3 WHERE { ?class a owl:Class. ?class rdfs:label ?cAns. ?class skos:definition ?AnswDefinition. FILTER(LANGMATCHES(LANG(?AnswDefinition),"en")) ?class (!(meta:subTopClass|meta:chapter)){1,2} ?dist1,?dist2,?dist3. owl:Class ^a ?dist1,?dist2,?dist3. FILTER(?class!=?dist1&&?class!=?dist2&&?class!=?dist3&&?dist1<?dist2&&?dist2<?dist3) ?dist1 rdfs:label ?dist1l. FILTER(LANGMATCHES(LANG(?dist1l),"en")) ?dist2 rdfs:label ?dist2l. FILTER(LANGMATCHES(LANG(?dist2l),"en")) ?dist3 rdfs:label ?dist3l. FILTER(LANGMATCHES(LANG(?dist3l),"en")) FILTER (STRLEN(?AnswDefinition)<225 && STRLEN(?AnswDefinition)>50). FILTER ( 1 > <bif:rnd> (10, ?class) ) FILTER (UCASE(SUBSTR(str(?AnswDefinition), 1, 1))) }ORDER BY RAND() LIMIT 50 } }GROUP BY ?class ORDER BY RAND()',
    # DEFINITION-Query
    'SELECT SAMPLE(str(?q)) as ?correctlabel SAMPLE(str(?ans)) as ?correct SAMPLE(str(?d1)) as ?distractor1 SAMPLE(str(?d2)) as ?distractor2 SAMPLE(str(?d3)) as ?distractor3 WHERE { ?class a owl:Class. ?class rdfs:label ?q. ?class skos:definition ?ans. ?class (!(meta:subTopClass|meta:chapter)){1,2} ?dist1,?dist2,?dist3. FILTER(?class!=?dist1&&?class!=?dist2&&?class!=?dist3&&?dist1<?dist2&&?dist2<?dist3). ?dist1 skos:definition ?d1. ?dist2 skos:definition ?d2. ?dist3 skos:definition ?d3. FILTER (STRLEN(?ans)<225). FILTER (STRLEN(?d1)<225). FILTER (STRLEN(?d2)<225). FILTER (STRLEN(?d3)<225). FILTER(LANGMATCHES(LANG(?ans),"en")). FILTER(LANGMATCHES(LANG(?q),"en")). FILTER(LANGMATCHES(LANG(?d1),"en")). FILTER(LANGMATCHES(LANG(?d2),"en")). FILTER(LANGMATCHES(LANG(?d3),"en")). } GROUP BY ?q ORDER BY RAND()',
    # LABEL-DEFINITION-Query
    'SELECT DISTINCT SAMPLE(str(?corrAns)) as ?corrAns SAMPLE(str(?responsibleFor)) as ?responsibleFor SAMPLE(str(?responsibility)) as ?responsibility SAMPLE(str(?distractor1)) as ?distractor1 SAMPLE(str(?distractor2)) as ?distractor2 SAMPLE(str(?distractor3)) as ?distractor3 { ?c1 rdfs:label ?corrAns. FILTER(LANGMATCHES(LANG(?corrAns),"en")) ?p rdfs:label ?responsibleFor. FILTER(LANGMATCHES(LANG(?responsibleFor),"en")) ?y rdfs:label ?responsibility. FILTER(LANGMATCHES(LANG(?responsibility),"en")) ?c2 rdfs:label ?distractor1. FILTER(LANGMATCHES(LANG(?distractor1),"en")) ?c3 rdfs:label ?distractor2. FILTER(LANGMATCHES(LANG(?distractor2),"en")) ?c4 rdfs:label ?distractor3. FILTER(LANGMATCHES(LANG(?distractor3),"en")) { SELECT DISTINCT ?c1 ?p ?y ?c2 ?c3 (SAMPLE(?c4) as ?c4) { meta:Role ^meta:subTopClass ?c4. ?c1 (!meta:subTopClass){1,2} ?c4. filter(?c1!=?c4&&?c2!=?c4&&?c3!=?c4&&?c1!=?y&&?c2!=?y&&?c3!=?y&&?c4!=?y) { SELECT DISTINCT ?c1 ?p ?y ?c2 (SAMPLE(?c3) as ?c3) { meta:Role ^meta:subTopClass ?c3. ?c1 (!meta:subTopClass){1,2} ?c3. filter(?c1!=?c3&&?c2!=?c3) { SELECT DISTINCT ?c1 ?p ?y (SAMPLE(?c2) as ?c2) { meta:Role ^meta:subTopClass ?c2. ?c1 (!meta:subTopClass){1,2} ?c2. filter(?c1!=?c2) { SELECT DISTINCT MIN(?c1) as ?c1 ?p ?y { ?y a owl:Class. ?c1 ?p ?y. ?c1 meta:subTopClass meta:Role. FILTER ( 1 > <bif:rnd> (10, ?y) ) } GROUP BY ?y ?p } } GROUP BY ?c1 ?p ?y } } } } } } GROUP BY ?corrAns ORDER BY RAND()'
    # RESPONSIBLE-FOR-Query
]

linebreak = ""


# Initialisierung der Variablen

def execute_query(type):
    # args: DEF, LDEF, RESP, ALL (entscheidet den Typ der Query.)
    # amount: 1-10 (Hauptgrund ist execution time, die sonst bei den Queries zu hoch wäre, da die Server relativ schwach sind -> dadurch nur 10 Fragen maximal)
    print("Führe mit Query-Typ " + type + " aus.")
    print("")
    if type == "DEF":
        s.setQuery(q[0] + " LIMIT 3")
        s.setTimeout(timeout=20)
        s.addExtraURITag("timeout", "9000")
        # Zeitlimit, da sonst die Query Timeout verursacht
        data = s.query()
        return data
    elif type == "LDEF":
        s.setQuery(q[1] + " LIMIT 3")
        s.setTimeout(timeout=20)
        s.addExtraURITag("timeout", "12500")
        # Zeitlimit, da sonst die Query Timeout verursacht
        data = s.query()
        return data
    elif type == "RESP":
        s.setQuery(q[2])
        s.setTimeout(timeout=20)
        data = s.query()
        return data
    else:
        return "ERROR: Query code"

def get_type():
    t = input("Query-Typ angeben [DEF|LDEF|RESP]:   ").upper()
    if t == "DEF" or t == "LDEF" or t == "RESP":
        return t
    else:
        get_type()

def get_format():
    f = input("Wo willst du die Fragen ansehen? [EXTERN|KONSOLE]:   ").upper()
    if f == "EXTERN" or f == "KONSOLE":
        return f
    else:
        get_format()

def get_name():
    n = input("Name für Quiz angeben (ohne Dateiendung):   ")
    if n == "":
        get_name()
    else:
        return n


type = get_type()
format = get_format()
if format == "EXTERN":
    print("Hinweis: Externe Quizdateien können in QuizMaster geöffnet werden. (Dateiendung .qmqf)")
    name = get_name()
    linebreak = "\n"
print("")
# Nutzereingabe für Programm erfassen

# try:
try:
    result = execute_query(type)
    # Query-Funktion ausführen

    # Ausführen der Query
    print("Ergebnis der Query:")
    print()
    towrite = []
    if format == "EXTERN":
        towrite.append(name + "\n")
        towrite.append("3\n")
    i = 0
    qCount = 0
    for row in result:
        if i>0:
            info = str(row)[3:-4].replace("\\xe2\\x80\\x99", "´")
            # Repariert die UTF-8-Formatierung
            files = info.split('","')
            # Teilt die einzelnen Fragen auf einen Array auf
            if type == "DEF":
                censored_title = files[0].replace(str(files[1]),"X")
                towrite.append('What is defined by "' + censored_title + '"?' + linebreak)
                towrite.append(files[1] + linebreak)
                towrite.append(files[2] + linebreak)
                towrite.append(files[3] + linebreak)
                towrite.append(files[4] + linebreak)
                # Einfügen der Fragen in eine Liste, Einfügen eines Linebreaks, falls als QuizMaster-Datei ausgegeben wird
                qCount = qCount + 1
                if format == "EXTERN":
                    towrite.append("4\n")
                else:
                    towrite.append("")
            elif type == "LDEF":
                towrite.append('How is "' + files[0] + '" defined?' + linebreak)
                towrite.append(files[1] + linebreak)
                towrite.append(files[2] + linebreak)
                towrite.append(files[3] + linebreak)
                towrite.append(files[4] + linebreak)
                qCount = qCount + 1
                if format == "EXTERN":
                    towrite.append("4\n")
                else:
                    towrite.append("")
            elif type == "RESP":
                if str(files[1])[:2] == "is" and qCount < 3:
                    if str(files[1])[:1]==" ":
                        towrite.append("What is " + files[0] + " " + str(files[1])[3:-1] + "?" + linebreak)
                    else:
                        towrite.append("What is " + files[0] + " " + str(files[1])[3:] + "?" + linebreak)
                    # Falls das letzte Zeichen ein Leerzeichen ist, entferne es. Ansonsten lasse das letzte Zeichen intakt.

                    # Fängt die Verantwortlichkeit mit "is" an (z.B. "is responsible for"), wird die Frage als gültig gewertet
                    # Zwischen is und das nächste Wort wird die Sache eingefügt, für die einer der Antwortmöglichkeiten verantwortlich ist
                    # Da manche Fragen keine Verantwortlichkeiten mit "is" besitzen, werden diese übersprungen, daher auch die Generierung von mehr als 3 Fragen, damit Überschuss vorhanden ist
                    # Sind 3 Fragen vorhanden, werden die restlichen übersprungen                    towrite.append(files[2] + linebreak)
                    towrite.append(files[2] + linebreak)
                    towrite.append(files[3] + linebreak)
                    towrite.append(files[4] + linebreak)
                    towrite.append(files[5] + linebreak)
                    if format == "EXTERN":
                        towrite.append("4\n")
                    if format == "KONSOLE":
                        towrite.append("")
                    qCount = qCount + 1
        i=i+1
    if format == "EXTERN":
        file = open(name + ".qmqf", "x")
        file.writelines(towrite)
        file.close()
        print("Datei erstellt.")
    else:
        print("Hinweis: Der Converter zeigt die Fragen nur an, sie sind nicht randomisiert. Die erste Antwort ist stets die Richtige.")
        print()
        for row in towrite:
            print(row)
    print("Auftrag fertiggestellt.")
    input()
except Exception as e:
    print(e)



# Max Wächtler, 2020-21