public static class NetworkPolicySpec {
    private String selector;
    private List<EgressRule> egress;
    private PodSelector podSelector;

    public String getSelector() {
        return selector;
    }

    public void setSelector(String selector) {
        this.selector = selector;
    }

    public List<EgressRule> getEgress() {
        return egress;
    }

    public void setEgress(List<EgressRule> egress) {
        this.egress = egress;
    }

    public PodSelector getPodSelector() {
        return podSelector;
    }

    public void setPodSelector(PodSelector podSelector) {
        this.podSelector = podSelector;
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

    public static class PodSelector {
        private String matchLabels;

        public String getMatchLabels() {
            return matchLabels;
        }

        public void setMatchLabels(String matchLabels) {
            this.matchLabels = matchLabels;
        }
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
