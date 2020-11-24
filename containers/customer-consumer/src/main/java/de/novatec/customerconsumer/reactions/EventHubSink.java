package de.novatec.customerconsumer.reactions;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.MapperFeature;
import com.microsoft.azure.spring.integration.core.AzureHeaders;
import com.microsoft.azure.spring.integration.core.api.reactor.Checkpointer;
import de.novatec.customerconsumer.model.Customer;
import de.novatec.customerconsumer.repository.CustomerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.stream.annotation.EnableBinding;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.cloud.stream.messaging.Sink;
import org.springframework.messaging.handler.annotation.Header;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

@EnableBinding(Sink.class)
public class EventHubSink {
  private static final Logger LOGGER = LoggerFactory.getLogger(EventHubSink.class);

  private final CustomerRepository customers;

  public EventHubSink(CustomerRepository customers) {
    this.customers = customers;
  }

  @StreamListener(Sink.INPUT)
  public void handleMessage(String message, @Header(AzureHeaders.CHECKPOINTER) Checkpointer checkpointer) {
    LOGGER.info("#### New message received: '{}'", message);
    ObjectMapper mapper = new ObjectMapper();
    try {
      //Because the event has capital attribute names, and java does not seem to like that
      mapper.configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true);
      JsonNode customerJson = mapper.readTree(message).get("Value");
      Customer customer = mapper.readValue(customerJson.toString(), Customer.class);
      customers.update(customer);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}
