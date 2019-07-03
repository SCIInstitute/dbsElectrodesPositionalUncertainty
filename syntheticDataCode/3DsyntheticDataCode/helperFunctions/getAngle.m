function ang = getAngle(w1,w2)

ang = atan2d(norm(cross(w1,w2)), dot(w1,w2));