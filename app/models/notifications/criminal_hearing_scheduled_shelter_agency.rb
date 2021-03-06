module Notifications
  class CriminalHearingScheduledShelterAgency < Base
    
    def self.create_for_match! match
      match.shelter_agency_contacts.each do |contact|
        create! match: match, recipient: contact
      end
    end

    def event_label
      label = _('Shelter Agency')
      label += ' '
      label += _('sent notice of criminal background hearing date.')
    end

  end
end
