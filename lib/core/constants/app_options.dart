/// Raw options used throughout Pitfolio.
/// Add or remove entries here whenever needed.
library;

const Map<String, String> currencies = {
  'INR': 'Indian Rupee (₹)',
  'USD': 'US Dollar (\$)',
  'SAR': 'Saudi Riyal (﷼)',
  'EUR': 'Euro (€)',
};

const Map<String, String> currencySymbols = {
  'INR': '₹',
  'USD': r'$',
  'SAR': '﷼',
  'EUR': '€',
};

const Map<String, String> distanceUnits = {
  'km': 'Kilometres (km)',
  'mi': 'Miles (mi)',
};

const Map<String, String> fuelCapacityUnits = {
  'L': 'Litres (L)',
  'gal': 'Gallons (gal)',
};

const Map<String, String> fuelTypes = {
  'petrol': 'Petrol',
  'diesel': 'Diesel',
  'cng': 'CNG',
  'electric': 'Electric',
  'hybrid': 'Hybrid',
  'lpg': 'LPG',
};

enum AttachmentType {
  vehiclePhoto,
  purchaseDocument,
  insurance,
  rc,
  puc,
  drivingLicence,
  serviceRecord,
  warranty,
  purchaseInvoice,
  other,
}
