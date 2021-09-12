CREATE DATABASE arrays;

SELECT ARRAY[1, 2, 3] <> ARRAY[3, 2, 1], -- equals
       ARRAY[1, 2, 3] @> ARRAY[1,2]; -- contains

SELECT ARRAY[1,2,3] || ARRAY[4,5,6]; -- concat

SELECT ARRAY[1,2,3] || 4; -- concat


SELECT array_append(ARRAY[1,2,3],5); -- append

SELECT array_cat(ARRAY[1,2,3],ARRAY[4,5,6]); -- concat

SELECT array_ndims(ARRAY[[1,2,3],[4,5,6]]); -- dimension
SELECT array_ndims(ARRAY[1,2,3]);

SELECT array_fill(1,ARRAY[2,3]);

SELECT array_length(ARRAY[1,2,3],1);

SELECT array_lower(ARRAY['Dog','Cat','Horse'],1);

SELECT array_position(ARRAY['Dog','Cat','Horse'],'Cat',3);

SELECT array_remove(ARRAY['Dog','Cat','Horse'],'Cat');









