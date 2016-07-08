class AddMatchRecommendationClientDecisionAttributes < ActiveRecord::Migration
  def change
    add_column :client_opportunity_matches, :match_recommendation_client_status, :string
    add_column :client_opportunity_matches, :match_recommendation_client_contact_id, :integer
    add_column :client_opportunity_matches, :match_recommendation_client_timestamp, :datetime
  end
end