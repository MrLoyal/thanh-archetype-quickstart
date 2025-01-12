mvn archetype:generate \
  -DgroupId=vn.loyal \
  -DartifactId=san \
  -Dversion=2.0 \
  -DarchetypeGroupId=com.thanh \
  -DarchetypeArtifactId=thanh-archetype-quickstart

mvn archetype:generate \
  -DgroupId=vn.loyal.learn \
  -DartifactId=learn-micrometer \
  -Dversion=1.0 \
  -DarchetypeGroupId=com.thanh \
  -DarchetypeArtifactId=thanh-archetype-quickstart