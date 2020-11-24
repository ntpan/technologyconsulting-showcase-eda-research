package de.novatec.customerconsumer.repository;

import de.novatec.customerconsumer.model.Customer;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@Repository
public class CustomerRepository {
  private Map<Integer, Customer> customers = new HashMap<>();

  public Collection<Customer> get() {
    return customers.values();
  }

  public void update(Customer customer) {
    customers.put(customer.getId(), customer);
  }
}
