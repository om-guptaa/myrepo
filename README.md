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
