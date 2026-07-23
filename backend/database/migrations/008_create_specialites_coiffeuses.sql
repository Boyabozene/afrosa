CREATE TABLE specialites_coiffeuses (
  coiffeuse_id UUID NOT NULL REFERENCES coiffeuses(id) ON DELETE CASCADE,
  soin_id UUID NOT NULL REFERENCES soins(id) ON DELETE CASCADE,
  PRIMARY KEY (coiffeuse_id, soin_id)
);
