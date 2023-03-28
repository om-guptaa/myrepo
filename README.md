# myrepo

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class EgressYamlComparator {

    public static void main(String[] args) throws IOException {
        String yamlFilePath1 = "egress1.yaml";
        String yamlFilePath2 = "egress2.yaml";

        ObjectMapper objectMapper = new ObjectMapper(new YAMLFactory());

        // read the first YAML file and extract the metadata name and egress hosts
        NetworkPolicy networkPolicy1 = objectMapper.readValue(new File(yamlFilePath1), NetworkPolicy.class);
        String metadataName1 = networkPolicy1.getMetadata().getName();
        Set<String> egressHosts1 = getEgressHosts(networkPolicy1);

        // read the second YAML file and extract the metadata name and egress hosts
        NetworkPolicy networkPolicy2 = objectMapper.readValue(new File(yamlFilePath2), NetworkPolicy.class);
        String metadataName2 = networkPolicy2.getMetadata().getName();
        Set<String> egressHosts2 = getEgressHosts(networkPolicy2);

        // compare the metadata names
        if (metadataName1.equals(metadataName2)) {
            System.out.println("Metadata names are the same: " + metadataName1);
        } else {
            System.out.println("Metadata names are different");
        }

        // compare the egress hosts
        if (egressHosts1.equals(egressHosts2)) {
            System.out.println("Egress hosts are the same: " + egressHosts1);
        } else {
            System.out.println("Egress hosts are different");
            Set<String> missingHosts = new HashSet<>(egressHosts1);
            missingHosts.removeAll(egressHosts2);
            System.out.println("Missing egress hosts: " + missingHosts);

            // generate CSV report of missing egress hosts
            String reportFilePath = "missing-egress-hosts.csv";
            try (FileWriter writer = new FileWriter(reportFilePath)) {
                writer.write("metadata_name, missing_hosts\n");
                writer.write(metadataName1 + ",");
                for (String host : missingHosts) {
                    writer.write(host + " ");
                }
            }
            System.out.println("CSV report generated at: " + reportFilePath);
        }
    }

    private static Set<String> getEgressHosts(NetworkPolicy networkPolicy) {
        Set<String> hosts = new HashSet<>();
        for (NetworkPolicyEgressRule egressRule : networkPolicy.getSpec().getEgress()) {
            List<NetworkPolicyPeer> peers = egressRule.getDestination().getPeers();
            for (NetworkPolicyPeer peer : peers) {
                String host = peer.getEndpoint().getHostname();
                hosts.add(host);
            }
        }
        return hosts;
    }
}


<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.12.5</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.dataformat</groupId>
    <artifactId>jackson-dataformat-yaml</artifactId>
    <version>2.12.5</version>
</dependency>

