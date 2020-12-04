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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import reactor.core.Disposable;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Component
public class EventHubSink {
  private static final Logger LOGGER = LoggerFactory.getLogger(EventHubSink.class);

  @Value("${azure.eventHub.connectionString}")
  private String eventHubConnectionString;

  @Value("${azure.eventHub.consumerGroup}")
  private String eventHubConsumerGroup;

  private final CustomerRepository customers;

  public EventHubSink(CustomerRepository customers) {
    this.customers = customers;
  }

  @PostConstruct
  public void handleMessage() {
    EventHubClientBuilder builder = new EventHubClientBuilder();
    builder.connectionString(eventHubConnectionString);
    builder.consumerGroup(eventHubConsumerGroup);
    EventHubConsumerAsyncClient client = builder.buildAsyncConsumerClient();

    // receive(startReadingAtEarliestEvent=true)
    client.receive(true)
            .subscribe(partitionEvent -> {
              EventData data = partitionEvent.getData();

              LOGGER.info("New message received: '{}'", data.getBodyAsString());
              ObjectMapper mapper = new ObjectMapper();
              try {
                //Because the event has capital attribute names, and java does not seem to like that
                mapper.configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true);
                JsonNode customerJson = mapper.readTree(data.getBodyAsString()).get("Value");
                Customer customer = mapper.readValue(customerJson.toString(), Customer.class);

                if(customer != null)
                    customers.update(customer);
              } catch (IOException e) {
                e.printStackTrace();
              }
              LOGGER.info("Contents of event as string: '{}'", data.getBodyAsString());
            }, error -> LOGGER.warn(error.toString()));
  }
}
