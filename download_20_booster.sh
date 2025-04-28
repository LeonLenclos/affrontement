$collection = "cards=14,15,16,17,18,20,21,22,23,25,26,27,28,29,30,32,34,35,36,39,40,41,42,44,47,48,49,50,51,52,53,54,56,57,58,61,62,64,65,66,67,68,69,71,73,74,75,76,77,78,79,80,81,82,83,84,85,";
$url = "http://192.168.1.39:8000";

for i in {0..20};
    do curl -d $collection -X POST ${url}/booster >> booster-$i.pdf ;
    done;

pdfunite booster-*.pdf boosters.pdf;
