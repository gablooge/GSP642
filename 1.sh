# #!/bin/bash
gcloud auth revoke --all

while [[ -z "$(gcloud config get-value core/account)" ]]; 
do echo "waiting login" && sleep 2; 
done

while [[ -z "$(gcloud config get-value project)" ]]; 
do echo "waiting project" && sleep 2; 
done


gcloud app create --region=us-central

gcloud alpha firestore databases create --region=us-central

git clone https://github.com/rosera/pet-theory

cd pet-theory/lab01

npm install @google-cloud/firestore
npm install @google-cloud/logging
npm install faker
npm install csv-parse

PROJECT_ID=$(gcloud config get-value project)
node createTestData 1000

node importTestData customers_1000.csv

# try next to find the second user from command line
# gcloud projects get-iam-policy $PROJECT_ID
SECOND_USER=student-01-f52fa6a270d1@qwiklabs.net

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=user:$SECOND_USER --role=roles/logging.viewer

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=user:$SECOND_USER --role roles/source.writer