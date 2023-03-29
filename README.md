import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

public class Main {
    public static void main(String[] args) {
        String filePath1 = "path/to/file1.yaml";
        String filePath2 = "path/to/file2.yaml";

        List<NetworkPolicyEgressRule> file1Rules = getEgressRules(filePath1);
        List<NetworkPolicyEgressRule> file2Rules = getEgressRules(filePath2);

        // Mapping metadata names with their corresponding hostnames
        Map<String, List<String>> file1MetaDataMap = mapMetadataNamesWithHosts(file1Rules);
        Map<String, List<String>> file2MetaDataMap = mapMetadataNamesWithHosts(file2Rules);

        // Finding missing hosts for each metadata name in file2
        List<String[]> missingHosts = new ArrayList<>();
        for (String metadataName : file1MetaDataMap.keySet()) {
            if (file2MetaDataMap.containsKey(metadataName)) {
                List<String> file1Hosts = file1MetaDataMap.get(metadataName);
                List<String> file2Hosts = file2MetaDataMap.get(metadataName);
                for (String host : file1Hosts) {
                    if (!file2Hosts.contains(host)) {
                        missingHosts.add(new String[] { metadataName, host });
                    }
                }
            }
        }

        // Writing missing hosts to CSV file
        try {
            FileWriter csvWriter = new FileWriter("missing_hosts.csv");
            csvWriter.append("Metadata Name, Missing Host\n");
            for (String[] row : missingHosts) {
                csvWriter.append(String.join(",", row) + "\n");
            }
            csvWriter.flush();
            csvWriter.close();
            System.out.println("Missing hosts written to missing_hosts.csv");
        } catch (IOException e) {
            System.out.println("Error writing to CSV file: " + e.getMessage());
        }
    }

    private static List<NetworkPolicyEgressRule> getEgressRules(String filePath) {
        List<NetworkPolicyEgressRule> egressRules = new ArrayList<>();
        Yaml yaml = new Yaml();
        try {
            Iterable<Object> documents = yaml.loadAll(new File(filePath));
            for (Object document : documents) {
                NetworkPolicy networkPolicy = (NetworkPolicy) document;
                if (networkPolicy.getTypes().contains("Egress")) {
                    List<NetworkPolicyEgressRule> egress = networkPolicy.getEgress();
                    if (egress != null) {
                        egressRules.addAll(egress);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error reading YAML file: " + e.getMessage());
        }
        return egressRules;
    }

    private static Map<String, List<String>> mapMetadataNamesWithHosts(List<NetworkPolicyEgressRule> rules) {
        Map<String, List<String>> metaDataMap = new HashMap<>();
        for (NetworkPolicyEgressRule rule : rules) {
            String metadataName = rule.getMetadataName();
            NetworkPolicyPeer destination = rule.getDestination();
            if (destination != null) {
                List<String> hosts = destination.getHosts();
                if (hosts != null) {
                    if (metaDataMap.containsKey(metadataName)) {
                        metaDataMap.get(metadataName).addAll(hosts);
                    } else {
                        metaDataMap.put(metadataName, hosts);
                    }
                }
            }
        }
        return metaDataMap;
    }
}




import java.util.*;
import org.yaml.snakeyaml.*;
import java.io.*;

public class NetworkPolicyParser {
    public static void main(String[] args) throws FileNotFoundException {
        // Load the YAML file into a String
        String yamlFile = new Scanner(new File("network_policy.yaml")).useDelimiter("\\Z").next();
        
        // Parse the YAML file into a Map
        Yaml yaml = new Yaml();
        List<Map<String, Object>> policies = (List<Map<String, Object>>) yaml.load(yamlFile);

        // Loop over each policy and extract the metadata.name and ports
        for (Map<String, Object> policy : policies) {
            Map<String, Object> metadata = (Map<String, Object>) policy.get("metadata");
            String name = (String) metadata.get("name");
            List<Integer> ports = new ArrayList<Integer>();
            List<Map<String, Object>> egressList = (List<Map<String, Object>>) policy.get("spec.egress");
            for (Map<String, Object> egress : egressList) {
                List<Integer> portList = (List<Integer>) egress.get("ports");
                ports.addAll(portList);
            }
            System.out.println(name + ": " + ports);
        }
    }
}



I apologize for the confusion. NetworkPolicy is a custom resource type in Kubernetes, and is not defined in the Java SDK by default. You will need to create a Java class that corresponds to the YAML structure of your NetworkPolicy resource.

Here is an example NetworkPolicy class that you can use:

java
Copy code
import java.util.List;
import java.util.Map;

public class NetworkPolicy {
    private String apiVersion;
    private String kind;
    private Metadata metadata;
    private Spec spec;

    public String getApiVersion() {
        return apiVersion;
    }

    public void setApiVersion(String apiVersion) {
        this.apiVersion = apiVersion;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public Metadata getMetadata() {
        return metadata;
    }

    public void setMetadata(Metadata metadata) {
        this.metadata = metadata;
    }

    public Spec getSpec() {
        return spec;
    }

    public void setSpec(Spec spec) {
        this.spec = spec;
    }

    public static class Metadata {
        private String name;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    public static class Spec {
        private String selector;
        private int order;
        private List<String> types;
        private List<EgressRule> egress;

        public String getSelector() {
            return selector;
        }

        public void setSelector(String selector) {
            this.selector = selector;
        }

        public int getOrder() {
            return order;
        }

        public void setOrder(int order) {
            this.order = order;
        }

        public List<String> getTypes() {
            return types;
        }

        public void setTypes(List<String> types) {
            this.types = types;
        }

        public List<EgressRule> getEgress() {
            return egress;
        }

        public void setEgress(List<EgressRule> egress) {
            this.egress = egress;
        }

        public static class EgressRule {
            private String action;
            private String protocol;
            private Destination destination;

            public String getAction() {
                return action;
            }

            public void setAction(String action) {
                this.action = action;
            }

            public String getProtocol() {
                return protocol;
            }

            public void setProtocol(String protocol) {
                this.protocol = protocol;
            }

            public Destination getDestination() {
                return destination;
            }

            public void setDestination(Destination destination) {
                this.destination = destination;
            }

            public static class Destination {
                private List<String> domains;
                private List<Integer> ports;

                public List<String> getDomains() {
                    return domains;
                }

                public void setDomains(List<String> domains) {
                    this.domains = domains;
                }

                public List<Integer> getPorts() {
                    return ports;
                }

                public void setPorts(List<Integer> ports) {
                    this.ports = ports;
                }
            }
        }
    }
}



import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

public class NetworkPolicyYamlReader {
    
    public static void main(String[] args) throws IOException {
        String filePath = "path/to/networkpolicy.yml";
        
        // Load the YAML file
        Yaml yaml = new Yaml();
        Iterable<Object> objects = yaml.loadAll(new File(filePath));
        
        // Process each object in the YAML file
        for (Object obj : objects) {
            Map<String, Object> map = (Map<String, Object>) obj;
            Map<String, Object> metadata = (Map<String, Object>) map.get("metadata");
            String metadataName = (String) metadata.get("name");
            
            Map<String, Object> spec = (Map<String, Object>) map.get("spec");
            List<Map<String, Object>> egressList = (List<Map<String, Object>>) spec.get("egress");
            
            List<String> hostsList = new ArrayList<String>();
            
            for (Map<String, Object> egressMap : egressList) {
                Map<String, Object> destination = (Map<String, Object>) egressMap.get("destination");
                List<String> domains = (List<String>) destination.get("domains");
                hostsList.addAll(domains);
            }
            
            // Print metadata name and hosts mapped in the file
            System.out.println("Metadata name: " + metadataName);
            System.out.println("Hosts: " + hostsList.toString());
        }
    }
}



