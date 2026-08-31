UPDATE soins
SET
  prix_salon_cdf = CASE nom
    WHEN 'Box braids mi-longues' THEN 112000.00
    WHEN 'Box braids longues' THEN 168000.00
    WHEN 'Vanilles / Twists' THEN 84000.00
    WHEN 'Soin hydratant profond' THEN 33600.00
    WHEN 'Shampoing + Brushing' THEN 28000.00
    WHEN 'Défrisage' THEN 50400.00
    WHEN 'Tissage mi-long' THEN 78400.00
    WHEN 'Pose de perruque' THEN 61600.00
    WHEN 'Coiffure mariage' THEN 224000.00
    WHEN 'Coiffure soirée' THEN 84000.00
    ELSE prix_salon_cdf
  END,
  prix_domicile_cdf = CASE nom
    WHEN 'Box braids mi-longues' THEN 154000.00
    WHEN 'Box braids longues' THEN 224000.00
    WHEN 'Vanilles / Twists' THEN 112000.00
    WHEN 'Soin hydratant profond' THEN 50400.00
    WHEN 'Shampoing + Brushing' THEN 42000.00
    WHEN 'Défrisage' THEN 70000.00
    WHEN 'Tissage mi-long' THEN 106400.00
    WHEN 'Pose de perruque' THEN 84000.00
    WHEN 'Coiffure mariage' THEN 280000.00
    WHEN 'Coiffure soirée' THEN 112000.00
    ELSE prix_domicile_cdf
  END;
