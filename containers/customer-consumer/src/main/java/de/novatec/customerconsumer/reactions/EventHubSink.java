package de.novatec.customerconsumer.reactions;

import com.azure.messaging.eventhubs.*;
import com.azure.messaging.eventhubs.models.PartitionContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.MapperFeature;
import de.novatec.customerconsumer.model.Customer;
import de.novatec.customerconsumer.repository.CustomerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import reactor.core.Disposable;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Component
public class EventHubSink {
  private static final Logger LOGGER = LoggerFactory.getLogger(EventHubSink.class);

  private final CustomerRepository customers;

  public EventHubSink(CustomerRepository customers) {
    this.customers = customers;
  }

  @PostConstruct
  public void handleMessage() {
    EventHubClientBuilder builder = new EventHubClientBuilder();
    builder.connectionString("Endpoint=sb://tc-eda-iac-prod-customer-eventhub.servicebus.windows.net/;SharedAccessKeyName=pubsub;SharedAccessKey=mQdJtgGxURm4kXqKA6wescg+QDt1KYaHswGB3E9OCsQ=;EntityPath=customerchanged");
    builder.consumerGroup("$Default");
    EventHubConsumerAsyncClient client = builder.buildAsyncConsumerClient();

    Disposable sub = client.receive(true)
            .subscribe(partitionEvent -> {
              PartitionContext pContext = partitionEvent.getPartitionContext();
              EventData data = partitionEvent.getData();

              LOGGER.info("#### New message received: '{}'", data.getBodyAsString());
              ObjectMapper mapper = new ObjectMapper();
              try {
                //Because the event has capital attribute names, and java does not seem to like that
                mapper.configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true);
                JsonNode customerJson = mapper.readTree(data.getBodyAsString()).get("Value");
                Customer customer = mapper.readValue(customerJson.toString(), Customer.class);
                customers.update(customer);
              } catch (IOException e) {
                e.printStackTrace();
              }
              System.out.printf("Contents of event as string: '%s'%n", data.getBodyAsString());
            }, error -> System.err.print(error.toString()));
  }
}
