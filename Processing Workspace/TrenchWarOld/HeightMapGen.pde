//Diamond-Square Step Algorithm
public class HeightMapGen { //SWEET MOTHER OF GOD IT WORKS
    private int mapSize;
    private int wide;
    private int high;
    private float variance;

    public HeightMapGen() {
        mapSize = (int)pow(2,9) + 1;
        wide = mapSize;
        high = mapSize;
        variance = 1;
    }

    public void setSize(int wide, int high) {
        this.wide = wide;
        this.high = high;

        float w = (float)ceil(log(wide)/log(2));
        float h = (float)ceil(log(high)/log(2));

        if(w > h) {
            mapSize = (int)pow(2,w) + 1;
        }
        else {
            mapSize = (int)pow(2,h) + 1;
        }
    }
    public void setmapSize(int n) {
        mapSize = (int)pow(2,n) + 1;
        wide = mapSize;
        high = mapSize;
    }
    public void setVariance(float v) {
        variance = v;
    }
    public float[][] generate() {
        float[][] map = new float[mapSize][mapSize];
        map[0][0] = random(1);
        map[0][map.length - 1] = random(1);
        map[map.length - 1][0] = random(1);
        map[map.length-1][map.length-1] = random(1);

        map = generate(map);

        if(wide < mapSize || high < mapSize) {
            float[][] temp = new float[wide][high];
            for(int i = 0; i < temp.length; i++) {
                temp[i] = Arrays.copyOf(map[i],temp[i].length);
            }
            map = temp;
        }
        
        //console printout of integer matrix representing heightmap
        
       /*for(int i = 0; i < map.length; i++) {
            for(int j = 0; j < map[i].length; j++) {
                System.out.print(" "+ (int)(Math.ceil(10*(map[i][j]))));
            }
            System.out.println("");
        }
        */
        
        return map;
    }
    public float[][] generate(float[][] map) {
        map = map.clone();
        int step = map.length - 1;

        float v = variance;

        while(step > 1) {
            for(int i = 0; i < map.length - 1; i += step) {
                for(int j = 0; j < map[i].length - 1; j += step) {
                    float average = (map[i][j] + map[i + step][j] + map[i][j + step] + map[i+step][j+step])/4;
                    if(map[i + step/2][j + step/2] == 0) {
                        map[i+step/2][j+step/2] = average + randVariance(v);
                    }
                }
            }
                for(int i = 0; i < map.length - 1; i += step) {
                    for(int j = 0; j < map.length - 1; j += step) {
                        if(map[i+step/2][j] == 0) {
                            map[i+step/2][j] = averageDiamond(map, i + step/2, j, step) + randVariance(v);
                        }
                        if(map[i][j + step/2] == 0) {
                            map[i][j + step/2] = averageDiamond(map, i, j+step/2, step) + randVariance(v);
                        }
                        if(map[i + step][j + step/2] == 0) {
                            map[i + step][j + step/2] = averageDiamond(map, i + step, j + step/2, step) + randVariance(v);
                        }
                        if(map[i + step/2][j + step] == 0) {
                            map[i + step/2][j + step] = averageDiamond(map, i + step/2, j + step, step) + randVariance(v);
                        }
                    }
                }
                v /= 2;
                step /= 2;
            }
            return map;
        }
        private float averageDiamond(float[][] map, int x, int y, int step) {
            int count = 0;
            float average = 0;

            if(x - step/2 >= 0) {
                count++;
                average += map[x - step/2][y];
            }
            if(x + step/2 < map.length) {
                count++;
                average += map[x + step/2][y];
            }
            if(y - step/2 >= 0) {
                count++;
                average += map[x][y - step/2];
            }
            if(y + step/2 < map.length) {
                count++;
                average += map[x][y + step/2];
            }
            return average/count;
        }
    private float randVariance(float v) {
        return random(1)*2*v - v; //this can end up being negative, resulting in huge sections of negative numbers. Handled in setupTerrain.
    }

}

