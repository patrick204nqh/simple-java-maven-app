#!/usr/bin/env bash
set -e

# Extract project name and version
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)

ARTIFACT="target/${NAME}-${VERSION}.jar"
S3_BUCKET="${S3_BUCKET:-my-jenkins-artifact}" # Use env var if set, fallback to default

if [ -f "$ARTIFACT" ]; then
  aws s3 cp "$ARTIFACT" "s3://${S3_BUCKET}/${NAME}-${VERSION}.jar"
  echo "Artifact uploaded to s3://${S3_BUCKET}/${NAME}-${VERSION}.jar"
  # Optionally delete the artifact after upload to save space
  rm -f "$ARTIFACT"
else
  echo "Artifact $ARTIFACT not found!"
  exit 1
fi
