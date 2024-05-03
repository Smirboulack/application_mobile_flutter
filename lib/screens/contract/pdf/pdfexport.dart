import 'dart:math';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sevenapplication/core/models/mission_model.dart';

Future<Uint8List> makePdf(MissionModel mission) async {
  final pdf = Document();

  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Container(height: 50),
            Text(
              "CONTRAT DE PRESTATION DE SERVICES",
              style: Theme.of(context).header2,
            ),
            Container(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ENTRE :",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                " ${mission.boss!.entreprise!.name}, demeurant à ${mission.boss!.entreprise!.address} et exerçant la profession de ${mission.boss!.entreprise!.sector} en étant immatriculé sous le numéro de SIRET : ${mission.boss!.entreprise!.siret} ci-après désigné « Le Prestataire »,",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ET :",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${mission.boss!.entreprise!.name}, dont le siège social est ${mission.boss!.entreprise!.address}, représentée par ${mission.boss!.username} dûment habilité à l'effet des présentes. ci-après désignée « Le Client »,",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "D'AUTRE PART,",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Le Prestataire et le Client sont dénommés collectivement les « Parties », et individuellement une « Partie ».",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PRÉAMBULE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Le Prestataire est un entrepreneur indépendant qui s'est inscrit sur la plateforme numériqueaccessible à l'adresse www.sevensales.fr/ (« sevenJobs ») pour développer sa clientèle dans son domaine. Le Client est une entreprise qui a recours à sevenJobs pour trouver des prestataires de services pour la réalisation de missions ponctuelles en raison d'une augmentation de son activité ou d'imprévus.",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "En considération de ses compétences et de son expérience, le Client a souhaité confier au Prestataire le soin d'exécuter, en toute indépendance, une mission (la « Mission »).",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Grâce à la technologie de sevenJobs, les Parties se sont rapprochées et se sont accordées sur les termes du présent accord contractuel (le « Contrat »).",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "CECI ÉTANT EXPOSÉ, IL A ÉTÉ CONVENU CE QUI SUIT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Article 1. Objet du Contrat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Le présent document est un contrat de prestation de services ayant pour objet de définir les conditions et les modalités selon lesquelles le Client confie au Prestataire l'accomplissement de la Mission dont la nature et les caractéristiques sont précisées en Annexe 1.",
              ),
            ),
            Container(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Les Parties s'engagent à collaborer de bonne foi et à faire leurs meilleurs efforts pour exécuter leurs obligations respectives.",
              ),
            ),
          ],
        );
      },
    ),
  );
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Article 2. Autonomie et indépendance",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "Les Parties exercent leur activité en totale autonomie et indépendance, chacune d'elles supportant les risques de son activité.",
            ),
            Container(height: 10),
            Text(
              "Le Prestataire n'est soumis à aucune obligation d'exclusivité vis-à-vis du Client. Le Prestataire est libre de conclure un/des contrat(s) similaire(s) ou équivalent(s) au Contrat avec toute personne physique ou morale, concurrente ou non du Client.",
            ),
            Container(height: 10),
            Text(
              "Article 3. Durée du Contrat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "Le Contrat entre en vigueur à compter de sa date de signature pour une durée déterminée, laquelle est détaillée dans l'Annexe 1 du Contrat.",
            ),
            Container(height: 10),
            Text(
              "Chaque Partie est libre de mettre un terme au Contrat en adressant à l'autre Partie un courrier électronique ou un message via l'application dans les hypothèses suivantes :",
            ),
            Container(height: 10),
            Text(
              "       - la Partie ne souhaite plus collaborer avec l'autre et lui notifie sa volonté expresse de",
            ),
            Text(
              "         ne pas poursuivre la collaboration ;",
            ),
            Container(height: 10),
            Text(
              "       -  l'autre Partie n'est plus en mesure d'exécuter les obligations lui incombant au titre",
            ),
            Text(
              "         du Contrat(par exemple, en cas de procédure collective ou de maladie) ;",
            ),
            Container(height: 10),
            Text(
              "       -  ou si l'autre Partie commet un manquement grave à une des stipulations du Contrat.",
            ),
            Container(height: 10),
            Text(
              "Les Parties conviennent d'exclure toute reconduction tacite du Contrat.",
            ),
            Container(height: 10),
            Text(
              "Article 4. Obligations du Prestataire",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "Le Prestataire s'engage à avoir les compétences, le savoir-faire, le matériel et les autorisations nécessaires pour être apte à la réalisation de la Mission.",
            ),
            Container(height: 10),
            Text(
              "Le Prestataire déclare qu'il respecte et s'engage à respecter toutes les lois et réglementations applicables à son statut et son activité, étant précisé qu'il sera seul responsable en cas de violation d'une d'entre elles. Plus particulièrement, le Prestataire déclare être à jour de l'ensemble de ses obligations sociales et fiscales et s'engage à les respecter pendant toute la durée du Contrat.",
            ),
            Container(height: 10),
            Text(
              "Le Prestataire assume à titre exclusif toutes les conséquences qui pourraient résulter de l'exécution de la Mission. Il est seul responsable des dommages subis ou causés par lui dans l'exécution de la Mission.",
            ),
            Container(height: 10),
            Text(
              "Article 5. Obligations du Client",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "Le Client s'engage à fournir, en temps utile, au Prestataire tous les documents, informations tenues à jour et toutes explications utiles à ce dernier pour exécuter dans les meilleures conditions possibles, la Mission lui incombant en vertu du Contrat.",
            ),
            Container(height: 10),
            Text(
              "En contrepartie de la réalisation de la Mission par le Prestataire, le Client s'engage à verser la somme prévue à l'Annexe 1 du Contrat.",
            ),
          ],
        );
      },
    ),
  );
  pdf.addPage(
    Page(
      build: (context) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Article 6. Déroulement de la Mission",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
          Container(height: 10),
          Text(
            "Le Prestataire s'engage à tout mettre en oeuvre pour réaliser la Mission dans les règles de l'art mais également à conseiller et/ou informer le Client sur la nature, les conditions d'exécution et toutes précautions utiles pour la réalisation de la Mission.",
          ),
          Container(height: 10),
          Text(
            "En tant que partenaire commercial indépendant, le Prestataire a un pouvoir d'initiative et est libre dans l'organisation ainsi que dans l'exécution de la Mission, à l'exception des contraintes inhérentes à la Mission (par exemple, l'existence d'un service, d'un événement ou encore l'hygiène et la sécurité).",
          ),
          Container(height: 10),
          Text(
            "Le Prestataire s'engage à mobiliser l'ensemble des moyens appropriés pour exécuter la Mission,étant précisé qu'il est seul maître de la définition desdits moyens et qu'il utilise ses propres moyens(notamment, moyen de déplacement, équipement de cuisine, gants de manutention, combinaisons spéciales, chaussures spéciales, méthodes de travail...), à l'exception de ceux fournis par le Client en raison d'obligations juridiques ou de contraintes de sécurité.",
          ),
          Container(height: 10),
          Text(
            "Article 7. Assurances",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
          Container(height: 10),
          Text(
            "À titre de condition essentielle et déterminante sans laquelle le Client ne se serait pas engagé, le Prestataire s'engage à être assuré dans les formes et conditions requises pour couvrir l'ensemble des risques inhérents à l'exercice de son activité commerciale, ce qui comprend ceux liés à la réalisation de la Mission.",
          ),
          Container(height: 10),
          Text(
            "Article 8. Confidentialité",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
          Container(height: 10),
          Text(
            "Chacune des Parties s'engage à ne pas divulguer à des tiers les informations confidentielles issues du Contrat et l'Annexe 1, et ce sur une durée de 2 ans à compter de la fin du Contrat.Le Prestataire s'engage à considérer et traiter comme confidentielles toutes les informations qui lui sont communiquées dans le cadre de l'exécution du Contrat, notamment les secrets de fabrication ou d'affaires et les spécifications industrielles, commerciales ou financières du Client. En conséquence, le Prestataire s'engage à ne pas divulguer à un tiers, de quelque façon que ce soit,tout ou partie des informations confidentielles sans l'accord préalable et écrit du Client.La violation des obligations visées ci-dessus peut être prouvée par tous moyens. De surcroît, le Client se réserve le droit de poursuivre le Prestataire en indemnisation des préjudices éventuellement subis à raison du non-respect, par le Prestataire, des obligations précitées.",
          ),
          Container(height: 10),
          Text(
            "Article 9. Divers",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
          Container(height: 10),
          Text(
            "Le Contrat comporte une annexe qui fait partie intégrante de l'accord contractuel des Parties, lequel constitue l'accord intégral entre les Parties et remplace les négociations, déclarations et accords ayant pour objet ou relatifs à l'exécution de la Mission, antérieurs à la date de signature du Contrat.",
          ),
          Container(height: 10),
          Text(
            "Au cas où une stipulation du Contrat s'avérait en tout ou partie nulle ou invalide, la validité des autres clauses du Contrat ne serait pas affectée.",
          ),
        ]);
      },
    ),
  );
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 10),
            Text(
              "Article 10. Loi applicable et juridiction compétente",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "Le Contrat est régi et interprété par le droit français.",
            ),
            Container(height: 10),
            Text(
              "Les Parties s'engagent à soumettre tout litige ou contestation relatif à la validité, à l'interprétation à l'exécution et/ou à la rupture du Contrat à la compétence exclusive du Tribunal de commerce de Paris.",
            ),
            Container(height: 10),
            Text(
              "Fait à Lyon le ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
            ),
            Container(height: 10),
            Text(
              "En deux exemplaires,",
            ),
            Container(height: 40),
            Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Le Prestataire,",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    "Nom :${mission.boss!.username}",
                  ),
                  Container(height: 10),
                  Text(
                    "Prénom :",
                  ),
                  Container(height: 10),
                  Text(
                    "Date: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                  ),
                ],
              ),
              Container(width: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Le Client,",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  Container(height: 10),
                  Text(
                    "Nom :${mission.boss!.username}",
                  ),
                  Container(height: 10),
                  Text(
                    "Prénom :",
                  ),
                  Container(height: 10),
                  Text(
                    "Date: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                  ),
                ],
              ),
            ]),
          ],
        );
      },
    ),
  );
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "ANNEXE 1 - DÉTAILS DE LA MISSION",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
            Container(height: 30),
            Text(
              "La Mission revêt les caractéristiques suivantes:",
            ),
            Container(height: 10),
            Text(
              "Nature de la Mission :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "Prestation de ${mission.service!.name}",
            ),
            Container(height: 10),
            Text(
              "Montant de la prestation (HT)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              "300 euros",
            ),
            Container(height: 10),
            Text(
              "Adresse de la mission : ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Container(height: 10),
            Text(
              mission.address!,
            ),
            Container(height: 10),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    Expanded(
                      child: Text(
                        'Date de début',
                        style: Theme.of(context).header4,
                        textAlign: TextAlign.center,
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Date de fin',
                        style: Theme.of(context).header4,
                        textAlign: TextAlign.center,
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Durée (dont temps de pause)',
                        style: Theme.of(context).header4,
                        textAlign: TextAlign.center,
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Total (dont temps de pause)',
                        style: Theme.of(context).header4,
                        textAlign: TextAlign.center,
                      ),
                      flex: 4,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Expanded(
                      child: PaddedText(DateFormat('dd MMMM yyyy')
                          .format(mission.startDate!)),
                      flex: 1,
                    ),
                    Expanded(
                      child: PaddedText(
                          DateFormat('dd MMMM yyyy').format(mission.endDate!)),
                      flex: 1,
                    ),
                    Expanded(
                      child: PaddedText(mission.heuresTravaux!),
                      flex: 1,
                    ),
                    Expanded(
                      child: PaddedText(mission.pauseTravaux!),
                      flex: 1,
                    )
                  ],
                ),
              ],
            ),
            Table(border: TableBorder.all(color: PdfColors.black), children: [
              TableRow(
                children: [
                  Expanded(
                      child: PaddedText('Total', align: TextAlign.right),
                      flex: 3),
                  Expanded(
                      child: PaddedText('Total', align: TextAlign.right),
                      flex: 1),
                ],
              ),
            ]),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
