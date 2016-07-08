class Rules::IncomeLessThanFiftyPercentAmi < Rule
  def clients_that_fit(scope, requirement)
    if income_total_monthly = Client.arel_table[:income_total_monthly]
      ami = 34350/12 #50% AMI
      if requirement.positive
        where = "income_total_monthly < ?"
      else
        where = "income_total_monthly >= ?"
      end
      scope.where(where, ami)
    else
      raise RuleDatabaseStructureMissing.new("clients.income_total_monthly missing. Cannot check clients against #{self.class}.")
    end
  end
end
