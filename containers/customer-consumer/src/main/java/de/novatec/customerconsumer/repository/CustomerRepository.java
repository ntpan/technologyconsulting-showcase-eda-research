package de.novatec.customerconsumer.repository;

import de.novatec.customerconsumer.controller.NotFoundExeption;
import de.novatec.customerconsumer.model.Customer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@Repository
public class CustomerRepository {
  private static final Logger log = LoggerFactory.getLogger(CustomerRepository.class);

  private Map<Integer, Customer> customers = new HashMap<>();

  public Collection<Customer> getAll() {
    return customers.values();
  }

  public Customer getById(int id) throws NotFoundExeption {
    if(!customers.containsKey(id))
      throw new NotFoundExeption();
    return customers.get(id);
  }

  public void update(Customer customer) {
    if(customers.containsKey(customer.getId())) {
      log.info("Customer with id {} exists. Updating customer to {}", customer.getId(), customer);
    } else {
      log.info("Creating new customer {}", customer);
    }
    customers.put(customer.getId(), customer);
  }
}
