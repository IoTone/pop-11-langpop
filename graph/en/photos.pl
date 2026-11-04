% graph/en/photos.pl -- GENERATED.  Do not edit; edit the JSON
% beside each photograph and re-run `tools/mkphoto.py graph`.
%
% Photographs for the `see` channel.  Unlike graph/*/generated/*.pl these
% ARE committed, for the reason docs/langpop-photographs.md gives: a wav
% regenerates from its text forever, a photograph is a one-off and has to
% be kept.  The JSON beside each one is the review record -- what was
% checked, and with which model.
%
% depicts/2    is plainly TRUE of the photograph
% misdepicts/2 is plainly FALSE of it
%
% Every statement here passed `mkphoto.py check`, which puts each one
% alone to a vision model that has not seen the prompt.  A statement the
% checker and a human disagree about is dropped, never adjudicated.
%
% Written by tools/mkphoto.py

item(ph_dog_walk, photo, en, a2, own(photos)).
photo(ph_dog_walk, 'graph/en/photos/ph_dog_walk.jpg').
depicts(ph_dog_walk, 'A woman is walking two dogs.').
depicts(ph_dog_walk, 'One of the dogs is on a leash.').
misdepicts(ph_dog_walk, 'A woman is walking three dogs.').
misdepicts(ph_dog_walk, 'Both of the dogs are on leashes.').
misdepicts(ph_dog_walk, 'The dogs are sitting on the pavement.').
misdepicts(ph_dog_walk, 'A man is riding a bicycle.').

item(ph_office_copier, photo, en, a2, own(photos)).
photo(ph_office_copier, 'graph/en/photos/ph_office_copier.jpg').
depicts(ph_office_copier, 'Two women are standing near a photocopier.').
depicts(ph_office_copier, 'Some papers are being held.').
misdepicts(ph_office_copier, 'A man is operating the photocopier.').
misdepicts(ph_office_copier, 'The women are sitting at a desk.').
misdepicts(ph_office_copier, 'The office is empty.').
misdepicts(ph_office_copier, 'The women are outside the building.').
